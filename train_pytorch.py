import os
import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, transforms, models
from torch.utils.data import DataLoader
import pandas as pd
from tqdm import tqdm

def main():
    # === 1) Paramètres ===
    data_dir       = '.'             
    train_dir      = os.path.join(data_dir, 'train')
    val_dir        = os.path.join(data_dir, 'test')
    checkpoint_dir = 'checkpoints'
    os.makedirs(checkpoint_dir, exist_ok=True)

    batch_size     = 32
    num_epochs     = 200
    learning_rate  = 1e-3
    device         = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

    # === 2) Préparation des données ===
    transform = transforms.Compose([
        transforms.Resize((180, 180)),
        transforms.ToTensor(),
        transforms.Normalize([0.485,0.456,0.406], [0.229,0.224,0.225])
    ])
    train_ds = datasets.ImageFolder(train_dir, transform=transform)
    val_ds   = datasets.ImageFolder(val_dir,   transform=transform)

    train_loader = DataLoader(train_ds, batch_size=batch_size, shuffle=True,  num_workers=4)
    val_loader   = DataLoader(val_ds,   batch_size=batch_size, shuffle=False, num_workers=4)

    class_names = train_ds.classes

    # === 3) Modèle ===
    model = models.mobilenet_v2(pretrained=True)
    model.classifier[1] = nn.Linear(model.last_channel, len(class_names))
    model = model.to(device)

    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=learning_rate)

    # === 4) Entraînement & validation ===
    history = []
    for epoch in range(1, num_epochs+1):
        # Entraînement
        model.train()
        running_loss, running_corrects = 0.0, 0
        for inputs, labels in tqdm(train_loader, desc=f"Epoch {epoch}/{num_epochs} [Train]"):
            inputs, labels = inputs.to(device), labels.to(device)
            optimizer.zero_grad()
            outputs = model(inputs)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()
            running_loss += loss.item() * inputs.size(0)
            running_corrects += (outputs.argmax(1) == labels).sum().item()
        epoch_loss = running_loss / len(train_ds)
        epoch_acc  = running_corrects / len(train_ds)

        # Validation
        model.eval()
        val_loss, val_corrects = 0.0, 0
        with torch.no_grad():
            for inputs, labels in tqdm(val_loader, desc=f"Epoch {epoch}/{num_epochs} [Val]"):
                inputs, labels = inputs.to(device), labels.to(device)
                outputs = model(inputs)
                loss = criterion(outputs, labels)
                val_loss += loss.item() * inputs.size(0)
                val_corrects += (outputs.argmax(1) == labels).sum().item()
        val_loss = val_loss / len(val_ds)
        val_acc  = val_corrects / len(val_ds)

        print(f"\nEpoch {epoch}: train_loss={epoch_loss:.4f}, train_acc={epoch_acc:.4f}, "
              f"val_loss={val_loss:.4f}, val_acc={val_acc:.4f}\n")

        # Sauvegarde des poids
        checkpoint_path = os.path.join(checkpoint_dir, f"weights_epoch{epoch}.pt")
        torch.save(model.state_dict(), checkpoint_path)

        history.append({
            'epoch': epoch,
            'train_loss': epoch_loss,
            'train_acc': epoch_acc,
            'val_loss': val_loss,
            'val_acc': val_acc,
            'checkpoint': checkpoint_path
        })

    # === 5) Sauvegarde des résultats ===
    df = pd.DataFrame(history)
    df.to_csv('results.csv', index=False)
    print("✅ Enregistrement terminé : results.csv et checkpoints/*.pt créés.")

if __name__ == '__main__':
    main()
