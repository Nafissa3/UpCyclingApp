from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from PIL import Image
import io

app = FastAPI()


@app.post("/analyze")
async def analyze_image(file: UploadFile = File(...)):
    # 1️⃣ Récupération du fichier
    contents = await file.read()
    image = Image.open(io.BytesIO(contents))

    # 2️⃣ Appel à ton modèle de ML
    # Ici, je mets un exemple simulé.
    # À toi de mettre TA VRAIE PRÉDICTION.
    result = {
        "components": ["plastique PET", "papier", "aluminium"],
        "final_score": 9.0,
        "suggestions": [
            "Réutilisez comme porte-crayon",
            "Recyclez dans le conteneur jaune"
        ]
    }

    # 3️⃣ Retourne le résultat en JSON
    return JSONResponse(content=result)
