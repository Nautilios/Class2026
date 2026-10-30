from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Ninja(BaseModel):
    nombre: str
    aldea: str
    rango: int
    habilidades: list[str]

class NinjaOfensivo(Ninja):
    ataque: int
    ninjutsu: int

class NinjaDefensivo(Ninja):
    defensa: int
    proteccion: int

class NinjaMedico(Ninja):
    curacion: int
    apoyo: int

class EquipoNinja(BaseModel):
    nombre: str
    integrantes: list[Ninja]
    def capacidad_total(self):
        return sum(ninja.rango for ninja in self.integrantes)

class Mision(BaseModel):
    rango_minimo: int
    habilidades_requeridas: list[str]
    tamano_minimo_equipo: int

@app.post("/evaluar_mision/")
def evaluar_mision(equipo: EquipoNinja, mision: Mision):
    puede_aceptar, mensaje = OficinaMisiones.puede_aceptar_mision(equipo, mision)
    return {"puede_aceptar": puede_aceptar, "mensaje": mensaje}

@app.get("/")
def read_root():
    return {"message": "Bienvenido a la Oficina de Misiones Ninja. Utiliza el endpoint /evaluar_mision/ para evaluar si un equipo puede aceptar una misión."}

@app.post("/crear_equipo/")
def crear_equipo(equipo: EquipoNinja):
    return {"message": f"Equipo {equipo.nombre} creado con éxito.", "equipo": equipo}

@app.post("/crear_mision/")
def crear_mision(mision: Mision):
    return {"message": "Misión creada con éxito.", "mision": mision}

@app.get("/listar_equipos/")
def listar_equipos(equipos: list[EquipoNinja]):
    return {"equipos": equipos}
















































