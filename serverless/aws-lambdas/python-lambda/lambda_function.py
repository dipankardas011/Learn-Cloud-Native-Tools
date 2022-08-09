import requests

def lambda_handler(event, context):
    res = requests.get("https://github.com/dipankardas011/")
    return {
        'statusCode': res.status_code,
        'headers': {
            'Content-Type': 'text/html'
        },
        'body': res.content
    }
