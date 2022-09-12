from Backend.schemas import DBNAME, UserLogIn
from Backend.functions import forgotPasswordEmail, getToken, hashPassword, isStrongPassword, verificationEmail, verifyPassword
from Backend.schemas import UserSignUp, database
from fastapi import APIRouter, Body, status, Response


authRouter = APIRouter()

@authRouter.post("/signup")
def SignUp(user_data: UserSignUp, response: Response): 
    user_data.email = user_data.email.lower()
    try:
        user_data.password = hashPassword(user_data.password)
        data = database[DBNAME]['Users'].insert_one(user_data.__dict__)
        token = getToken({"data":str(data.inserted_id)})
        database[DBNAME].create_collection(user_data.name+"."+token)   
        return {"success":"User Created", "token":token}
    except:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"failure":"there is something error try again later, or check your connection"}

        
        
@authRouter.post("/login")
def login(user : UserLogIn,response: Response):
    for data in database[DBNAME]["Users"].find():
        if user.email.lower() == data['email'].lower() and verifyPassword(user.password, data["password"]):
            return {"name":data['name'],"success":"User Logged in", "token":getToken({"data":str(data['_id'])})}
    else: 
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"failure": "Wrong email or password"}

@authRouter.post("/forgotpassword")
def forgotPassword(response: Response, email: str = Body(...)):
    for user in database[DBNAME]["Users"].find():
        if user['email'].lower() == email.lower():
            return {"otp":str(forgotPasswordEmail(email))}
    else:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"failure":"User doesn't exists"}

@authRouter.post("/verifyuser")# this function happens before sign up
def verifyUser(response: Response, user: UserSignUp):
    if isStrongPassword(user.password):
        for person in database[DBNAME]["Users"].find():
            database[DBNAME]["Users"].find_one({"email":user.email})
            if person['email'] == user.email:
                response.status_code = status.HTTP_409_CONFLICT
                return {"failure":"UserExists already"}
        else:
            try: 
               return{"otp": verificationEmail(user.email)}
            except:
                response.status_code = status.HTTP_405_METHOD_NOT_ALLOWED
                return {"failure":"There is an error in email or check your connection"}
                
    else:
        response.status_code = status.HTTP_406_NOT_ACCEPTABLE
        return {"failure":"weak password it must be at least 10 characters with special symbols"}

@authRouter.put("/forgotpassword/changepassword")
def changePassword(user: UserLogIn,response:Response):
    if isStrongPassword(user.password):
        user.email = user.email.lower()
        user.password = hashPassword(user.password)
        database[DBNAME]["Users"].find_one_and_update({"email":user.email}, {"$set":{"password":user.password}})
        response.status_code = status.HTTP_201_CREATED
        return {"success": "Password updated"}
    else:
        return {"failure":"weak password it must be at least 10 characters with special symbols"}

######################### FINISHED ##############################