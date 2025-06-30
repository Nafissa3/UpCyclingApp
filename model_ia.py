# predict_function.py
import json
from ultralytics import YOLO

# Traduction et scores de recyclage
CLASS_MAPPING = {
    "cardboard": "carton",
    "glass": "verre",
    "metal": "métal",
    "organic": "déchets organiques",
    "paper": "papier",
    "plastic": "plastique"
}
RECYCLING_SCORES = {
    "cardboard": 4,
    "glass": 5,
    "metal": 4,
    "organic": 1,
    "paper": 4,
    "plastic": 3
}

def predict_image(image_path: str, model_path: str = "C:/Users/enafi/Desktop/CyclingDetection/weights/best.pt") -> dict:
    """Prédit la classe d'une image et retourne un dictionnaire avec le résultat."""
    model = YOLO(model_path)
    results = model.predict(source=image_path, save=False, imgsz=640)

    # Extraction de la meilleure prédiction
    pred_class_id = int(results[0].boxes.cls[0])
    pred_class_en = model.names[pred_class_id]
    pred_class_fr = CLASS_MAPPING.get(pred_class_en, pred_class_en)
    score = RECYCLING_SCORES.get(pred_class_en, 0)

    return {
        "prediction": pred_class_fr,
        "score_recyclage": score
    }

# Exemple d'utilisation
def main():
    image = "C:/Users/enafi/Desktop/CyclingDetection/test_image.jpg"
    output = predict_image(image)
    with open("prediction.json", "w", encoding="utf-8") as f:
        json.dump(output, f, indent=4, ensure_ascii=False)
    print("✅ Prédiction enregistrée dans prediction.json")

if __name__ == "__main__":
    main()
