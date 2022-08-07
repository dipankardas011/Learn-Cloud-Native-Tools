import json

def lambda_handler(event, context):
    message = 'Hello {} {}!'.format(event['first_name'], event['last_name'])
    age = event['age']
    YEAR = 2022
    age = YEAR - age
    message += '\tBirth year: {}!'.format(age)
    return {
        'message' : message
    }
