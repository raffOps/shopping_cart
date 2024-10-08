include .env
export $(shell sed 's/=.*//' .env)

SONAR_PATH = ~/sonar/bin


zip_lambda:
	rm -f ./lambda.zip
	cd ./venv/lib/python3.12/site-packages && zip -r9 ../../../../lambda.zip .
	cd app && zip -g ../lambda.zip -r . -x "*/__pycache__/*"


deploy_lambda: zip_lambda
	aws lambda update-function-code --function-name shopping_cart_api --zip-file fileb://lambda.zip


sonar:
	echo $(SONAR_PATH)
	 ${SONAR_PATH}/sonar-scanner \
	  -Dsonar.token=${SONAR_TOKEN}
