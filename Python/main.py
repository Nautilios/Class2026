from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

misiones = [
    {
        "id": 1,
        "nombre": "Explorar Marte",
        "destino": "Marte",
        "tripulante": 4
    },
    {
        "id": 2,
        "nombre": "Estacion Lunar",
        "destino": "Luna",
        "tripulante": 2
    }
]

class Mision(BaseModel):
    nombre: str
    destino: str
    tripulante: int

@app.get("/")
def inicio():
    return {"mensaje": "Centro de control espacial, bienvenido"}

@app.get("/misiones")
def misiones():
    return misiones

@app.get("/buscar")
def buscar_misiones(destino: str):
    resultados = []

    for mision in misiones:
        if mision["destino"].lower() == destino.lower():
            resultados.append(mision)

    return resultados


@app.post("/misiones")
def agregar_misiones(mision: Mision):
    nuevo_id = len(misiones) + 1
    nueva_mision = {
        "id": nuevo_id,
        "nombre": mision.nombre,
        "destino": mision.destino,
        "tripulante": mision.tripulante
    }

    misiones.append(nueva_mision)
    return nueva_mision