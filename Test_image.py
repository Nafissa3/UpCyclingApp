from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import numpy as np

model = load_model("modele_recyclage.h5")

img_path = "mon_image.jpg"
img = image.load_img(img_path, target_size=(180, 180))
img_array = image.img_to_array(img)
img_array = tf.expand_dims(img_array, 0) / 255.0  # Normalisation

predictions = model.predict(img_array)
classes = ['cardboard', 'compost', 'glass', 'metal', 'paper', 'plastic', 'trash']
print("Prédiction :", classes[np.argmax(predictions)])
