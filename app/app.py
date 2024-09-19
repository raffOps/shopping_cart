import boto3
from repositories.dynamodb import DynamoDBRepository

def main():
    dynamodb = boto3.resource('dynamodb')
    repo = DynamoDBRepository(dynamodb)
    print("ok")


if __name__ == '__main__':
    main()