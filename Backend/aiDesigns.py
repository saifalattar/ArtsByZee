from fastapi import APIRouter, Body, status, Response
from functions import isValidToken
from functions import forgotPasswordEmail, getToken, hashPassword, isStrongPassword, verificationEmail, verifyPassword
import tensorflow as tf
from tensorflow import keras
import numpy as np

imagesLinks=[
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/0.png?alt=media&token=30d4fd85-00f9-4a7e-ae41-d4496cdf5c4e",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/1.png?alt=media&token=e1fdef52-4807-452b-9b11-b12eed953831",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/2.png?alt=media&token=32d48cda-b6d1-428e-9a0b-8ca10bfd8b35",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/3.png?alt=media&token=905ecb04-41da-4cfb-816d-c9ca6e660524",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/4.png?alt=media&token=3df72d00-8ecd-4482-b8e1-88753259ce61",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/5.png?alt=media&token=12c0052a-6a7b-4ea6-8d3e-fbb627faf5c4",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/6.png?alt=media&token=08954238-a56d-4794-a4a4-7e749876d0f5",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/7.png?alt=media&token=448e1dc6-eb16-471b-9acb-98dfeba3b49d",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/8.png?alt=media&token=9ad0612b-550f-4f92-a51b-6fb6b2c23881",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/9.png?alt=media&token=c8998a6c-24c8-4a3a-8109-59a98ebe567a",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/10.png?alt=media&token=4a5a147a-89bb-4be2-abda-b43313d7220c",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/11.png?alt=media&token=8936ed4b-7c4e-4394-ac4f-793bf505d3e8",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/12.png?alt=media&token=06ef911f-555c-4cf5-b8fd-4a3100df2268",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/13.png?alt=media&token=4f5d774b-3f60-4658-9f79-b6c0d63370f2",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/14.png?alt=media&token=1e4808a6-2e2b-4b98-a3b2-79827a8c4459",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/15.png?alt=media&token=f1927b26-b1aa-4a95-acb4-5cb3a057fbd8",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/16.png?alt=media&token=d81802f4-f1dc-4bb0-9d96-acfa12d7d581",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/17.png?alt=media&token=43b111e5-8b1f-4ba3-9aa1-7c694973e4c4",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/18.png?alt=media&token=2502bbbd-bd7c-4b66-9566-93fbd2369d07",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/19.png?alt=media&token=df30cab1-e966-425f-a520-14ffba0736b7",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/20.png?alt=media&token=bf638730-6b63-4306-9c16-85122b2f73f8",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/21.jpg?alt=media&token=f109803a-5235-4e52-94b1-2651ec433274",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/22.jpg?alt=media&token=cd13ddde-1801-4a3a-9927-1ba5cb2d98cc",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/23.jpg?alt=media&token=2896fd4f-b30e-4653-9976-b3b2f9492b2f",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/24.png?alt=media&token=47f355d0-e543-4e2d-a454-c98be9999eca",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/25.png?alt=media&token=27df0deb-9e9c-43b6-92d9-6fd1443ad981",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/26.png?alt=media&token=0c42d9f1-beac-4267-8c2c-53017d41df5b",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/27.jpg?alt=media&token=02164b27-67b5-462a-b4e7-1308a9a055ae",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/28.png?alt=media&token=9733b22b-0cb9-40f1-bae8-65fcff00e96e",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/29.png?alt=media&token=23098b75-c17d-4629-9da4-32ca38b671dd",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/30.png?alt=media&token=b83ccd96-e6eb-453b-9d76-ac3eecc17c38",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/31.png?alt=media&token=f08e5a5e-bae2-41dc-9f18-9bdf4bf73c7a",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/32.jpg?alt=media&token=cfa6ab16-0724-4610-8693-d2558d49c65c",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/33.jpg?alt=media&token=0e8d110e-977e-47c6-8018-95f32eb0c425",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/34.png?alt=media&token=530a64c2-4061-4c1d-be86-c46a92c85adc",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/35.png?alt=media&token=e2d20f0c-46ec-49be-af64-0e6047845ee9",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/36.png?alt=media&token=4f9ca889-499d-4289-ad78-e057dd1fdf92",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/37.png?alt=media&token=fc82bb1a-da13-4c9b-b19d-9dd373a2e9cb",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/38.png?alt=media&token=2b31f21b-1635-4e52-bb5a-d171c00bf25d",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/39.png?alt=media&token=37293f1d-2981-417f-aa90-d1ee9e30d0ad",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/40.png?alt=media&token=89b9c2e1-8b09-43b8-bca8-5f0a26eddcc1",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/41.png?alt=media&token=a56b0541-148e-4096-a974-bd9f62a94f1f",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/42.png?alt=media&token=180007b3-910e-47bc-8ce9-c7ee628c7d8b",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/43.png?alt=media&token=80e57801-341e-4dbd-8ee9-45f5e46a6b4d",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/44.png?alt=media&token=a76789a0-8712-4d03-ab35-ab40ba285ba1",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/45.png?alt=media&token=5e198b81-db68-4752-93d6-6d64e7aa65f1",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/46.png?alt=media&token=8b7d12e9-998c-423f-b041-e0cc5d6035df",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/47.png?alt=media&token=0667564f-653e-4f19-91a5-1a666cd0695d",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/48.png?alt=media&token=eb33ffc5-c3db-4b35-a242-feebb64ba665", 
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/49.png?alt=media&token=5c88acbd-02c8-4dfb-a9c0-13015049bd28",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/50.png?alt=media&token=a17b93ee-32f5-40cb-aace-06d0bb94142e",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/51.png?alt=media&token=fa0bb11e-c3f2-4e8c-9a94-552caad55b82",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/52.png?alt=media&token=1b7fd4eb-9df4-4383-a564-c4f3c4d1c9fb",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/53.png?alt=media&token=88673ec8-921a-48c2-b34b-01fa1e9f1932",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/54.png?alt=media&token=dddf69a2-31ac-41d6-bd35-3e4d83692fc8",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/55.png?alt=media&token=ac96ebfe-bd4b-42d1-859c-a3f376637f7b",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/56.png?alt=media&token=c850ad4e-c69b-4cde-a35c-b7b3b8b03485",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/57.png?alt=media&token=72d4f022-327d-4db8-a145-a6739b728a00",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/58.png?alt=media&token=c14b0814-c2c5-4a41-8943-a84750eb86c2",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/59.png?alt=media&token=44cef203-d68b-43cd-888e-0f68d3dcf8f4",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/60.png?alt=media&token=ae126b96-86e5-44bf-8424-b6f38190300a",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/61.png?alt=media&token=738fd8e0-1d83-4faa-aae7-38068c7421ec",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/62.png?alt=media&token=fb5a12fa-f3c6-40f5-8dbd-ea3cf95c54ce",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/63.png?alt=media&token=1f0ee953-bef9-4c3e-81e5-129649fc821b",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/64.png?alt=media&token=4dcf7470-fb56-4623-aba1-c9d2cb1d4756",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/65.png?alt=media&token=244df56d-ecf0-42f4-a534-720416e89900",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/66.png?alt=media&token=648d047c-b176-4de4-a195-319a98cf3d30",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/67.png?alt=media&token=bd024f87-41dd-4b52-9498-cb24dc004a14",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/68.png?alt=media&token=8cc682c2-7d16-4811-a40e-aeb094a1538e",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/69.png?alt=media&token=714bc6d7-029b-45ed-8b65-d86cac7c19f0",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/70.png?alt=media&token=d1cb348e-c18f-466d-a4b8-4eddefd32e42",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/71.png?alt=media&token=36f49be7-12c8-4fcf-9c59-ad8e7bdc44e5",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/72.png?alt=media&token=4fe3709e-3849-4741-94d7-b1e1e8eeb2bb",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/73.png?alt=media&token=afbeb0fe-310e-4e68-92f8-0d6ce3e10ba6",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/74.png?alt=media&token=e6b9b200-0e54-4fab-a9b0-c5e251208038",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/75.png?alt=media&token=a5d099c2-b9f7-4b5e-977c-e08028720b85",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/76.png?alt=media&token=b4742535-4c01-4efd-992d-108e2036d7fb",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/77.png?alt=media&token=28f6f2bc-7b81-4c80-9352-c74cb722e72e",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/78.png?alt=media&token=5dd1a5bb-8f0a-4a52-9c8a-78eb65742f6b",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/79.png?alt=media&token=b391b834-3ff6-477e-98d1-69bae6ba7de7",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/80.png?alt=media&token=988a3a98-fd4f-4eac-a031-cfb4ba5c866f",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/81.png?alt=media&token=138d395c-28ae-4c22-adfd-40e86f4b5722",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/82.png?alt=media&token=281e4cab-a57c-4ca5-a2f9-dde1d268f295",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/83.png?alt=media&token=1bddbe41-0a44-4a84-8749-c736fca742bd",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/84.png?alt=media&token=a7a26617-cea2-4417-a019-da828bd6e0f2",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/85.png?alt=media&token=3d6bccb6-28e3-4232-8ddf-5c9b209fbed1",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/86.png?alt=media&token=03174621-64c5-4469-b4b4-93ac98de3cfb",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/87.png?alt=media&token=813ac94a-48e1-4217-9952-3eec3fb02b9c",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/88.png?alt=media&token=83647297-3b09-46aa-8052-799d1fb5d61a",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/89.png?alt=media&token=8e667a11-14c7-4af4-ad61-ff66e4da642c",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/90.png?alt=media&token=ef4620fd-0837-4559-943c-377125d074d3",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/91.png?alt=media&token=3a2fb435-547f-42f1-8b07-499f014b31c3",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/92.png?alt=media&token=034733ae-a5ec-42a2-bb35-f33989a33c6f",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/93.png?alt=media&token=03a57354-b7e6-45c4-ad48-28306d3289cd",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/94.png?alt=media&token=53ff0064-1347-4791-9323-c0a563587750",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/95.png?alt=media&token=2b0af465-fc48-42b5-bd8d-6999157961b5",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/96.png?alt=media&token=cfe80656-4429-44fe-8d74-49c7b765c93b",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/97.png?alt=media&token=a7ce8f13-c9d6-44ec-9a09-a3b278caf34b",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/98.png?alt=media&token=43de978b-f5cd-4b87-8682-0bddb03fbf69",
    "https://firebasestorage.googleapis.com/v0/b/ghaith-app.appspot.com/o/99.png?alt=media&token=e73eb121-8c3d-43d9-a46a-4ee908c175a2"
]

AiDesigns = APIRouter()

@AiDesigns.post("/Ai/getDesigns/{token}")
def generateAiDesign(token, response:Response, data: dict=Body(...)):
    if isValidToken(token):
        model = keras.models.load_model("artsByZee.model")
        predict = model.predict(np.array([data["list"]]))
        images = []
        for i in range(len(predict[0])):
            if predict[0][i] > 0.1:
                images.append(imagesLinks[i])
        return images
    else:
        response.status_code = status.HTTP_401_UNAUTHORIZED
        return {"failure":"Something error with your token, please re-login"}
