from cmath import sqrt


def quadratic(a, b, c):
    x = sqrt(b*b - 4*a*c)
    return (a + x) / (2.0 *a)

def lambda_handler(event, context):
    res = quadratic(event['a'], event['b'], event['c'])
    return str(res)