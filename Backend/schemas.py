from typing import Optional
import pydantic
import pymongo

database = pymongo.MongoClient("mongodb+srv://saif:Saif%402002@zeena.wscmopw.mongodb.net/?retryWrites=true&w=majority")

DBNAME = "ZeenaStore"

class UserLogIn(pydantic.BaseModel):
    email: str
    password: str

class UserSignUp(UserLogIn):
    name: str
    phoneNumber: str

class Product(pydantic.BaseModel):
    name: str 
    description: str
    price: float
    images: list

class Order(pydantic.BaseModel):
    product : Product
    address: str
    userName: str
    phoneNumber: str
    describe: str

################################ FINISHED #############################
