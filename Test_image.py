import tensorflow as tf # type: ignore
from tensorflow.keras.models import load_model # type: ignore
from tensorflow.keras.preprocessing import image # type: ignore
import numpy as np
import matplotlib.pyplot as plt

# Charger le modèle
model = load_model("modele_recyclage.h5")

# Liste des classes
classes = ['cardboard', 'compost', 'glass', 'metal', 'paper', 'plastic', 'trash']

# Chemin de l'image à prédire
img_path = "mon_image.png"  # 🔁 Mets le chemin complet si l'image n'est pas dans le même dossier

# Charger et prétraiter l'image
img = image.load_img(img_path, target_size=(180, 180))
img_array = image.img_to_array(img)
img_array = tf.expand_dims(img_array, 0) / 255.0  # Normalisation

import os
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import numpy as np
import matplotlib.pyplot as plt

# 1. Afficher le dossier de travail actuel
print("Dossier courant :", os.getcwd())

# 2. Lister les fichiers présents
print("Contenu du dossier :", os.listdir(os.getcwd()))

# 3. Chemin vers le modèle
model_path = "modele_recyclage.h5"
print("Chemin vers le modèle :", model_path)

# 4. Vérifier existence
if not os.path.exists(model_path):
    raise FileNotFoundError(f"❌ Impossible de trouver le modèle à l’emplacement {model_path}")

# 5. Charger le modèle
model = load_model(model_path)

# ... suite du code pour prédiction et affichage ...

# Prédiction
predictions = model.predict(img_array)
predicted_index = np.argmax(predictions)
predicted_label = classes[predicted_index]

# Afficher le résultat
print(f"✅ Prédiction : {predicted_label}")

# Afficher l'image avec matplotlib
plt.imshow(img)
plt.title(f"Prédiction : {predicted_label}")
plt.axis('off')
plt.show()
