# Condiciones Técnicas
# Python
# FastAPI
# POO(Clases y objetos)
# Pydantic(validación)
# Listas en memoria
# Manejo de errores HTTP

# Reglas de negocio
# No permitir reservas si no hay cupos disponibles
# No permitir reservar mas personas de las que admite el paquete
# Al reservar, disminuir los cupos disponibles
# Al cancelar, devolver los cupos
# No permitir cancelar dos veces la misma reserva
# No permitir reservar paquetes inexistentes


from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

app = FastAPI(title="Agencia de Viajes")
# #Paquetes Turisticos
# * Registrar paquetes turisticos.
# * Consultar todos los paquetes.
# + Consultar un paquete por su ID.
# * Cada paquete debe tener: destino, precio,
# «capacidad méxima y cupos disponibles.

paquete_turistico = [
    {
        "id": 1,
        "destino": "Paris",
        "precio": 1000,
        "capacidad_maxima": 20,
        "cupos_disponibles": 10
    },
    {
        "id": 2,
        "destino": "Londres",
        "precio": 1200,
        "capacidad_maxima": 15, 
        "cupos_disponibles": 8
    },
    {
        "id": 3,
        "destino": "Roma",
        "precio": 1100,
        "capacidad_maxima": 18,
        "cupos_disponibles": 12
    }
]
# Reservas
# * Registrar una reserva asociada a un cliente y un paquete.
# * Consultar todas las reservas.
# * Cancelar una reserva.
# * Consultar las reservas de un cliente.

reservas = [
    {
        "id": 1,
        "cliente": "Juan Perez",
        "paquete_id": 1,
        "cantidad_personas": 2
    },
    {
        "id": 2,
        "cliente": "Maria Lopez",
        "paquete_id": 2,
        "cantidad_personas": 1
    },
    {
        "id": 3,
        "cliente": "Carlos Ruiz",
        "paquete_id": 3,
        "cantidad_personas": 3
    }
]

class PaqueteTuristico(BaseModel):
    id: int
    destino: str
    precio: float
    capacidad_maxima: int
    cupos_disponibles: int

#Health
@app.get("/")
def inicio():
    return {"message": "Bienvenido a la Agencia de Viajes"}

@app.get("/paquetes/{paquete_id}", tags=["Paquetes Turisticos"])
def obtener_paquete(paquete_id: int):
    for paquete in paquete_turistico:
        if paquete["id"] == paquete_id:
            return paquete
    raise HTTPException(status_code=404, detail="Paquete no encontrado")

@app.post("/paquetes", status_code=201, tags=["Paquetes Turisticos"])
def crear_paquete(paquete: PaqueteTuristico):
    nuevo_paquete = len(paquete_turistico) + 1

    nuevo_paquete = {
        "id": nuevo_paquete,
        "destino": paquete.destino,
        "precio": paquete.precio,
        "capacidad_maxima": paquete.capacidad_maxima,
        "cupos_disponibles": paquete.cupos_disponibles
    }
    paquete_turistico.append(nuevo_paquete)
    return nuevo_paquete