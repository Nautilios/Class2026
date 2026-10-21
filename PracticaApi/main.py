# Of course. Here is the complete text from the image:

# ---

# # PARCIAL DE PROGRAMACIÓN DE PYTHON · POO 2

# ## OFICINA DE MISIONES NINJA
# **KONOHA TE NECESITA**

# ### CONTEXTO

# La aldea de Konoha necesita modernizar su sistema de asignación de misiones. El Hokage solicita una API que permita registrar ninjas, formar equipos, consultar misiones y verificar si un equipo puede aceptar una misión.

# ### REQUISITOS

# 1. Crear una clase base Ninja y diferentes tipos de ninjas que hereden de ella.
# 2. Aplicar polimorfismo en el cálculo de la capacidad de combate o habilidades de cada ninja.
# 3. Implementar la lógica para validar si un equipo puede aceptar una misión (rangos, habilidades, cantidad de integrantes, capacidad total, etc.).
# 4. Exponer las operaciones mediante una API REST con FastAPI.
# 5. Desplegar el proyecto en Railway o Render.

# ### EVALUACIÓN
# **5,0 PUNTOS**

# *   ```text
#     Herencia y polimorfismo
#     1,0 punto
#     ```
# *   Lógica de negocio y validaciones
#     2,0 puntos
# *   ```text
#     API REST con FastAPI
#     1,0 punto
#     ```
# *   Despliegue en Railway o Render
#     1,0 punto

# ### MODELO DEL SISTEMA

# *   ```text
#     Ninja (clase base)
#     Nombre • Aldea
#     Rango • Chakra
#     Habilidades
#     ```
# *   NinjaOfensivo
#     (ataque y ninjutsu)
# *   NinjaDefensivo
#     (defensa y protección)
# *   NinjaMedico
#     (curación y apoyo)
# *   ```text
#     EquipoNinja
#     (Nombre • Integrantes
#     Capacidad total)
#     ```
# *   ```text
#     Mision
#     (Rango mínimo
#     Habilidades requeridas
#     Tamaño mínimo de equipo)
#     ```
# *   ```text
#     OficinaMisiones
#     (Evalúa si el equipo
#     puede aceptar la misión)
#     ```

# ### RANGOS

# | Rango | Valor |
# | :--- | :--- |
# | Genin | 1 |
# | Chunin | 2 |
# | Jonin | 3 |
# | Kage | 4 |

# *   \* El rango determina el nivel mínimo que debe tener cada integrante del equipo para aceptar la misión.

# ### EJEMPLO DE HABILIDADES

# *   Ninjutsu
# *   Taijutsu
# *   Genjutsu
# *   Medicina
# *   Defensa
# *   Sigilo
# *   Elemental (Fuego, Agua, Rayo, Viento, Tierra)

# _Cada ninja puede tener una o varias habilidades._

# ### PRUEBA FINAL

# Crea al menos un equipo y una misión. Demuestra que el equipo cumple con todas las condiciones para aceptarla. La API debe devolver un resultado claro (éxito o rechazo) con los motivos.

# ---

# **¡Demuestra que tu equipo está listo para la misión!**



































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

class OficinaMisiones:
    @staticmethod
    def puede_aceptar_mision(equipo: EquipoNinja, mision: Mision):
        if len(equipo.integrantes) < mision.tamano_minimo_equipo:
            return False, "El equipo no cumple con el tamaño minimo requerido."
        
        for ninja in equipo.integrantes:
            if ninja.rango < mision.rango_minimo:
                return False, f"El ninja {ninja.nombre} no cumple con el rango minimo requerido."
        
        habilidades_equipo = set()
        for ninja in equipo.integrantes:
            habilidades_equipo.update(ninja.habilidades)
        
        if not all(habilidad in habilidades_equipo for habilidad in mision.habilidades_requeridas):
            return False, "El equipo no posee todas las habilidades requeridas para la misión."
        
        return True, "El equipo puede aceptar la misión."

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




























































