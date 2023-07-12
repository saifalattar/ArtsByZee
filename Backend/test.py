from requests import delete, post


d = post("http://192.168.1.6:8000/Ai/getDesigns/zeenaTheAdmin2002", data={"list":[8, 0, 2, 3]})
print(d.text)

# d = get("http://192.168.1.6:8000/tutorials/zeenaTheAdmin2002")
# print(d.text)