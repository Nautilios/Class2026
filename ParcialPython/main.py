from fastapi import FastAPI

app = FastAPI(title="Parcial Python")


@app.get("/")
def root():
    return {"mensaje": "API funcionando"}
