```shell
pip install --target ./package requests
cd package
zip -r ../my-deployment-package.zip .
cd ..
zip -g my-deployment-package.zip lambda_function.py
```

example to directly create lambda fun and upload the zip
```sh
aws lambda create-function --function-name my-function --zip-file fileb://my-deployment-package.zip --handler lambda_function.lambda_handler --runtime python3.8 --role arn:aws:iam::your-account-id:role/lambda-ex
```
