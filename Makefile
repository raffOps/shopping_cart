deploy_lambda_image:
	poetry export --without-hashes --format=requirements.txt > requirements.txt
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 010526247757.dkr.ecr.us-east-1.amazonaws.com
	docker build -t lambda_cart .
	docker tag lambda_cart:latest 010526247757.dkr.ecr.us-east-1.amazonaws.com/lambda_cart:latest
	docker push 010526247757.dkr.ecr.us-east-1.amazonaws.com/lambda_cart:latest

zip_lambda:
	rm -f ./lambda.zip
	cd ./venv/lib/python3.12/site-packages && zip -r9 ../../../../lambda.zip .
	cd app && zip -g ../lambda.zip -r . -x "*/__pycache__/*"


deploy_lambda: zip_lambda
	aws lambda update-function-code --function-name shopping_cart_api --zip-file fileb://lambda.zip