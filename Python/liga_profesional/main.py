from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

app = FastAPI(title="Liga pro API")

equipos = [
	{"id": 1, "nombre": "Robapollo RFC", "ciudad": "Santa Marta"},
	{"id": 2, "nombre": "Los Pumas", "ciudad": "Bogotá"},
]

class EquipoEntrada(BaseModel):
	nombre: str 
	ciudad: str