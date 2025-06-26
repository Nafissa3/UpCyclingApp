import torch
import torchvision.transforms as transforms
from PIL import Image
from torchvision import models
import torch.nn as nn
import os
import json

# === PARAMÈTRES ===
image_path = "C:/Users/enafi/Desktop/UPCYCLING/mon_image3.png"
weights_path = "C:/Users/enafi/Desktop/UPCYCLING/checkpoints/weights_epoch200.pt"
class_names = ['cardboard', 'compost', 'glass', 'metal', 'paper', 'plastic', 'trash']
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

# === SCORE DE RECYCLAGE ===
recyclage_score = {
    'compost': 5,
    'cardboard': 4,
    'glass': 4,
    'metal': 4,
    'paper': 3,
    'plastic': 2,
    'trash': 1
}

# === PRÉTRAITEMENT ===
transform = transforms.Compose([
    transforms.Resize((180, 180)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

# === CHARGER IMAGE ===
img = Image.open(image_path).convert("RGB")
img_tensor = transform(img).unsqueeze(0).to(device)

# === CHARGER MODÈLE ===
model = models.mobilenet_v2(pretrained=False)
model.classifier[1] = nn.Linear(model.last_channel, len(class_names))
model.load_state_dict(torch.load(weights_path, map_location=device))
model = model.to(device)
model.eval()

# === PRÉDICTION ===
with torch.no_grad():
    outputs = model(img_tensor)
    predicted_class = class_names[torch.argmax(outputs).item()]
    score = recyclage_score.get(predicted_class, 0)

# === ÉCRIRE EN JSON ===
result = {
    "prediction": predicted_class,
    "score_recyclage": score
}

with open("prediction.json", "w", encoding="utf-8") as f:
    json.dump(result, f, indent=4, ensure_ascii=False)

print("✅ Résultat JSON écrit dans 'prediction.json'")
