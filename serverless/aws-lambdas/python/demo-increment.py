import json

def lambda_handler(event, context):
    a = event['a']
    a += 1
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Number ": event['a'],
            "NewNumber": a
        })
    }
