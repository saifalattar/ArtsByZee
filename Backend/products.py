from fastapi import APIRouter, Header ,Body, Response, status
from bson import ObjectId
from schemas import DBNAME, Product, database

products = APIRouter()

# viewing ,adding and getting products from database

############## For admin only ######################

@products.post("/admin/addProduct")
def addProduct(response: Response, theProduct: Product):
    try:
        database[DBNAME]["Products"].insert_one(theProduct.__dict__)
        return {"success":f"{theProduct.name} added successfully\nShatoora ya Zozza"}
    except:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"failure":"Can't add this product right now again later Zeena or call me"}

@products.delete("/admin/deleteProduct")
def deleteProduct(response: Response,productId: dict = Body(...)):
    try:
        product = database[DBNAME]["Products"].find_one_and_delete({"_id":ObjectId(productId["id"])})
        return {"success" : f"{product['name']} has been deleted successfully"}
    except:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"failure":"Can't delete this product for now try again later Zeena or call me!!!"}


# @products.get("/admin/getProduct")
# def getProductFromId(productId: str = Body(...)):
#     product = database[DBNAME]["Products"].find_one({"_id":ObjectId(productId)})
#     product["_id"] = str(product["_id"])
#     return product

@products.get("/admin/get_all_orders")
def getAllOrders(response: Response):
    try:
        func = database[DBNAME]["Orders"].find()
        orders = []
        for i in func:
            i["_id"] = str(i["_id"])
            orders.append(i)
        return orders
    except:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"failure":"Can't get orders right now\nTry again later ya zeena or call me"}

@products.delete("/admin/complete_order")
def completeOrder(response: Response, productId: dict = Body(...)):
    try:
        database[DBNAME]["Orders"].find_one_and_delete({"_id":ObjectId(productId["id"])})
        return {"success":"Order accomplished \n Good job ZEENAAA keep going"}
    except:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"failure":"Can't do this right now\nTry again later ya zeena or call me"}

@products.get("/admin/get_all_number_of_orders")
def getAnalytics():
    return {"totalNum":database[DBNAME]["Admin"].find_one({"_id":ObjectId("631df4e59b1d4214058d5cc2")})["numberOfOrders"]}
####################################### FINISHED #######################################################

