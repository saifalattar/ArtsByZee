from Backend.trading import trading
from fastapi import FastAPI
from Backend.auth import authRouter
from Backend.products import products

app = FastAPI()

@app.get("/")
def hello():
    return "HELLOOO"

app.include_router(authRouter)
app.include_router(products)
app.include_router(trading)