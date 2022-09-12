from fastapi import APIRouter, Header ,Body
from bson import ObjectId
from Backend.schemas import DBNAME, Product, database

products = APIRouter()

# viewing ,adding and getting products from database

############## For admin only ######################

@products.post("/admin/addProduct")
def addProduct(theProduct: Product):
    try:
        product = database[DBNAME]["Products"].insert_one(theProduct.__dict__)
        #print(product.__dict__)
        return {"success":f"{theProduct.name} added successfully"}
    except:
        return {"failure":"Can't add this product right now again later Zeena"}

@products.delete("/admin/deleteProduct")
def deleteProduct(productId: str = Body(...)):
    try:
        product = database[DBNAME]["Products"].find_one_and_delete({"_id":ObjectId(productId)})
        return {"success" : f"{product['name']} has been deleted successfully"}
    except:
        return {"failure":"Can't delete this product for now try again later Zeena!!!"}


@products.get("/admin/getProduct")
def getProductFromId(productId: str = Body(...)):
    product = database[DBNAME]["Products"].find_one({"_id":ObjectId(productId)})
    product["_id"] = str(product["_id"])
    return product

@products.delete("/admin/complete_order")
def completeOrder(productId: str = Body(...)):
    try:
        database[DBNAME]["Orders"].find_one_and_delete({"_id":ObjectId(productId)})
        return {"success":"Order accomplished \n Good job ZEENAAA keep going"}
    except:
        return {"failure":"Can't do this right now try again later"}

@products.get("/admin/get_all_number_of_orders")
def getAnalytics():
    return {"totalNum":database[DBNAME]["Admin"].find_one({"_id":ObjectId("631df4e59b1d4214058d5cc2")})["numberOfOrders"]}
####################################### FINISHED #######################################################

