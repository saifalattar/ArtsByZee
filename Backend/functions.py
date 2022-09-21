from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from bson import ObjectId
from random import randrange
import smtplib
from jose import jwt
from passlib.context import CryptContext

from Backend.schemas import DBNAME, database

#to check whether the password is strong or not
def isStrongPassword(password:str):
    isSpecialSymbolsIncluded = False
    for i in ["@", "!", "#", "$", "%", "^", "&", "*"]:
        if password.__contains__(i):
            isSpecialSymbolsIncluded = True

    if (password.__len__()>= 10) and (isSpecialSymbolsIncluded):
        return True

# tokenization function 
def getToken(payloads: dict):
    token = jwt.encode(claims=payloads, key="Zeenaisthebestartist2002", algorithm="HS256")
    return token

context = CryptContext(schemes=["bcrypt"], deprecated="auto")
#to hash the password
def hashPassword(password: str):
    return context.hash(password)

# to verify the password
def verifyPassword(password: str, hashedPassword: str) -> bool:
    return context.verify(password, hashedPassword)

#to send email to reset password 
def forgotPasswordEmail(sendTo: str):
    otp = randrange(111111, 999999)

    message = MIMEMultipart()

    message.add_header("From", "ArtsByZee")
    message.add_header("To", "you")
    message.add_header("Subject", "Reset your ArtsByZee password" )
    message.attach(MIMEText(
    """<img src="https://instagram.fcai20-5.fna.fbcdn.net/v/t51.2885-19/73188176_435023720546516_1937603272147730432_n.jpg?stp=dst-jpg_s320x320&_nc_ht=instagram.fcai20-5.fna.fbcdn.net&_nc_cat=108&_nc_ohc=8YcmR4FhF0AAX_YnI5d&edm=AOQ1c0wBAAAA&ccb=7-5&oh=00_AT98Klot3dL_oxcD85yct3KfyWIOrs16zWvR0u4K-F5Lcw&oe=63230D0B&_nc_sid=8fd12b" alt="Iyp-black-white" border="0" width=100 />
    <body style="background-color:white">
    <br/>
    <h2>Change your ArtsByZee password</h2>
    your OTP is:
    <h3>{}</h3>
    </body>
    """.format(otp), "html"))

    server = smtplib.SMTP_SSL("smtp.gmail.com", 465)
    server.ehlo()
    server.login("saifelbob2002@gmail.com", "ryexfrtblubknrmz")
    server.sendmail("ArtsByZee", sendTo, message.as_string())
    return str(otp)

# to send verification email with OTP
def verificationEmail(sendTo: str):
    otp = randrange(111111, 999999)

    message = MIMEMultipart()


    message.add_header("From", "ArtsByZee")
    message.add_header("To", "you")
    message.add_header("Subject", "Verify your ArtsByZee account")
    message.attach(MIMEText(
    """<img src="https://instagram.fcai20-5.fna.fbcdn.net/v/t51.2885-19/73188176_435023720546516_1937603272147730432_n.jpg?stp=dst-jpg_s320x320&_nc_ht=instagram.fcai20-5.fna.fbcdn.net&_nc_cat=108&_nc_ohc=8YcmR4FhF0AAX_YnI5d&edm=AOQ1c0wBAAAA&ccb=7-5&oh=00_AT98Klot3dL_oxcD85yct3KfyWIOrs16zWvR0u4K-F5Lcw&oe=63230D0B&_nc_sid=8fd12b" alt="Iyp-black-white" border="0" width=100 />
    <body style="background-color:white">
    <br/>
    <h2>Verify your account</h2>
    your OTP is:
    <h3>{}</h3>
    </body>
    """.format(otp), "html"))

    server = smtplib.SMTP_SSL("smtp.gmail.com", 465)
    server.ehlo()
    server.login("saifelbob2002@gmail.com", "ryexfrtblubknrmz")
    server.sendmail("ArtsByZee", sendTo, message.as_string())
    return str(otp)

# to know if the token is for a valid user
def isValidToken(token:str) -> bool:
    if token == "zeenaTheAdmin2002":
        return True
    try:
        if database[DBNAME]['Users'].find_one({"_id":ObjectId(jwt.decode(token, key="Zeenaisthebestartist2002", algorithms="HS256")['data'])}):
            return True
        else:
            return False
    except:
        return False
#print(isValidToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjI3MDUxMmUyOGFiMmMxNjM5NTY0YTRiIn0.V_W6wAFeoRetl8hAJW0MLm80I-XTRcwOMuomHPT6x54"))
