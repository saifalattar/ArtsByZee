import requests

data = requests.post("http://192.168.1.15:8000/test", data={"email":"saifelbob2002@gmail.com"})
print(data.text)