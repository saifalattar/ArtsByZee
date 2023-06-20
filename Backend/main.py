from trading import trading
from fastapi import FastAPI
from auth import authRouter
from products import products
from tutorials import tutorials

app = FastAPI()

@app.get("/")
def hello():
    return "HELLOOO"

app.include_router(authRouter)
app.include_router(products)
app.include_router(trading)
app.include_router(tutorials)