import requests
def lambda_handler(event, context):
    res = requests.get("https://www.civo.com/")
    print(res.text)
    return res.text
