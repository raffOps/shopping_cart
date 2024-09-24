import json
import logging
import random
from typing import Any
from datetime import datetime

import boto3
from botocore.exceptions import ClientError

from app.domain.models.shopping_cart import Shopping_Cart

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

def get_topic(sns_resource, topic_arn: str) -> Any:
    topics = sns_resource.topics.all()
    for topic in topics:
        if topic.attributes["TopicArn"] == topic_arn:
            return topic
    return None

def publish(topic: Any) -> None:
    buyer_id = random.randint(1, 1000)
    while True:
        cart = Shopping_Cart(
            buyer_id=buyer_id,
            product_id=2,
            number_of_installments=2,
            total_amount=100,
            purchase_date=datetime.now(),
        )
        try:
            response = topic.publish(Message=cart.model_dump_json())
            print(f"published cart: {cart}, response: {response}")

        except ClientError:
            logger.exception("Couldn't publish message to topic %s.", topic.arn)
            raise
        buyer_id += 1


def main() -> None:
    sns_resource = boto3.resource("sns")
    topic = get_topic(sns_resource, "arn:aws:sns:us-east-1:010526247757:shopping_cart")
    publish(topic)


if __name__ == "__main__":
    main()
