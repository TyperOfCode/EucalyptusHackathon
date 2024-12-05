import base64
from typing import Union, Optional
import json
from fastapi import FastAPI, UploadFile, HTTPException, File
from groq import Groq
from dotenv import load_dotenv, find_dotenv
load_dotenv(find_dotenv())

from nutrition import nutrition_search

client = Groq()
app = FastAPI()

@app.post("/api/submitReceipt")
def process_receipt(file: UploadFile = File(...)):
    receipt_image = None
    try:
        receipt_image = file.file.read()
    except:
        raise HTTPException(status_code=500, detail="Failed to upload image")
    finally:
        file.file.close()
    
    #                                   SAVING API CREDITS FOR THE MOMENT
    # receipt_json = ocr_from_groq(receipt_image)
    # if receipt_json is None:
    #     raise HTTPException(status_code=500, detail="Failed to visually recognise receipt")
    receipt_json = json.loads("""{
        "items": [
            "SELECT SAUCE HOISIN 320ML",
            "QUICK EZEE ORIGINAL 60 TAB",
            "QUEEN ESSENCE INITATVANILLA 200ML",
            "THIGH FILLET RSPCA APPROVED CHKN",
            "ICONA F/O COFFEE CLASC .DRK RST 400G",
            "MAINLAND CHEESE TASTY 1KG",
            "ENERGY DRINK SUGARFREE 4X275ML",
            "UNICORN TRIPLE CREAMBRIE 125G",
            "MISSION CORN CHIPS EXTREME CHEESE 230G",
            "MISSION CHEESY NACHOS CRN CHIPS 230G",
            "MISSION CORN OFFER"
        ]
    }""")

    results = []
    for item_name in receipt_json["items"]:
        nutrition_row = nutrition_search(item_name)
        if nutrition_row is None:
            results.append({})
            continue

        common_name = nutrition_row["Food Name"].split(",")[0]
        results.append({
            "name": common_name,
            "energy_kj": nutrition_row["energy_kj"].replace(",", ""),
            # ... there are so many other nutrition information we can pluck out (literally 100 columns)
        })

    return { "results": results }


@app.post("/api/testEcho")
def test_echo(data: str):
    return data

def ocr_from_groq(image: bytes) -> Optional[str]:
    base64_image = base64.b64encode(image).decode("utf-8")

    completion = client.chat.completions.create(
        model="llama-3.2-90b-vision-preview",
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": """
                            List all the names of items in the receipt image in JSON format.
                            I do not want the price.
                            Do not modify the letters of any of these names. Do not omit any letters in the name.
                            Keep the same ordering as it appears on the receipt.
                            Do not include lines that are not the names of food items.
                            If you are unsure, do not include the line.
                            Turn all names to uppercase.

                            An example would be 
                            { items: ["choc coated sticks 10pk 865mL", "Dairy Farmers Milk whole 1L BTL"] }.
                        """
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{base64_image}",
                        },
                    }
                ]
            },
        ],
        temperature=0.8,
        max_tokens=1024,
        top_p=1,
        stream=False,
        response_format={"type": "json_object"},
        stop=None,
    )

    return completion.choices[0].message.content
    
def call_with_bland():
    pass
  