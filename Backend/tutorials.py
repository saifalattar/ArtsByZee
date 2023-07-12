from fastapi import APIRouter, Body, Response, status
from bson import ObjectId
from schemas import DBNAME, database, Tutorial
from functions import isValidToken
from typing import Optional


tutorials = APIRouter()

@tutorials.get("/tutorials/{token}")
def getAllTutorials(token, response: Response):
    if isValidToken(token):
        tuts = []
        for tut in database[DBNAME]["Tutorials"].find():
            tut["_id"] = str(tut["_id"])
            tuts.append(tut)
        return tuts
        
    else:
        response.status_code = status.HTTP_401_UNAUTHORIZED
        return {"failure": "Something error with your token re-login please"}

@tutorials.post("/tutorials/{token}")
def postTutorial(token,response:Response, tut: Tutorial):
    if isValidToken(token):
        database[DBNAME]["Tutorials"].insert_one(tut.__dict__)
        return {"success":"Tutorial uploaded successfully"}
    else:
        response.status_code = status.HTTP_401_UNAUTHORIZED
        return {"failure": "Something error with your token re-login please"}

@tutorials.delete("/admin/deleteTutorial")
def deleteTutorial(response: Response, tutorialId: dict = Body(...)):
    try:
        tutorial = database[DBNAME]["Tutorials"].find_one_and_delete(filter={"_id":ObjectId(tutorialId["id"])})
        return {"success":f"The tutorial \"{tutorial['title']}\" has been deleted successfully"}
    except:
        response.status_code = status.HTTP_400_BAD_REQUEST
        return {"failure": "Something error happend ZOZZA, Call me :)"}
     