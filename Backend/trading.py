from datetime import date
import datetime
from fastapi import APIRouter, Header, Body
from Backend.schemas import DBNAME, Order, database
from Backend.functions import isValidToken
from bson import ObjectId


trading = APIRouter()

#getting all the products
@trading.get("/usersPage/products")
def getProducts(token: str = Header(...)):
    if(isValidToken(token)):
        products = []
        for p in database[DBNAME]["Products"].find():
            p["_id"] = str(p["_id"])
            products.append(p)
        return products
    else:
        return {"failure":"Something error with your token"}

# searching for specific product in database
@trading.get("/usersPage/products/search")
def searchProduct(token: str = Header(...), search: str = Body(...)):
    if(isValidToken(token)):
        products = []
        database[DBNAME]["Products"].create_index([("name", "text")])

        for p in database[DBNAME]["Products"].find({"$text": {"$search": f"\"{search}\"" } } ):
            p["_id"] = str(p["_id"])
            products.append(p)
        return products
    else:
        return {"failure":"Something error with your token"}

# make an Order
@trading.post("/usersPage/products/{productID}/order_this_product")
async def makeAnOrder(productID: str, order :Order, token: str = Header(...)):
    if(isValidToken(token)):       
        order.product = order.product.__dict__
        database[DBNAME]["Orders"].insert_one(order.__dict__)

        #increase the number of orders one
        database[DBNAME]["Admin"].find_one_and_update({"_id":ObjectId("631df4e59b1d4214058d5cc2")}, {"$inc":{"numberOfOrders": 1}})
        
        # insert the date and product id in user profile
        database[DBNAME][token].insert_one({"time":datetime.datetime.now(), "productID":productID})
        return {"success":"Your order has been submited successfully"}
    else:
        return {"failure":"Something error with your token"}

############################ FINISHED ###################################