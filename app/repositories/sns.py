import logging
from abc import ABC
from typing import Any

from botocore.exceptions import ClientError

from domain.models.shopping_cart import Shopping_Cart
from domain.ports import Shopping_Cart_Topic_Repository_Port

logger = logging.getLogger("sns")

shopping_cart_topic_arn = "arn:aws:sns:us-east-1:010526247757:shopping_cart"


class SnsRepository(Shopping_Cart_Topic_Repository_Port, ABC):
    def __init__(self, conn: Any):
        self.sns_resource = conn
        self.shopping_cart_topic = get_topic(self.sns_resource, shopping_cart_topic_arn)

    def publish_cart(self, cart: Shopping_Cart) -> Shopping_Cart:
        cart_json = cart.model_dump_json()
        try:
            response = self.shopping_cart_topic.publish(Message=cart_json)
            message_id = response["MessageId"]
        except ClientError as e:
            logger.warning("Couldn't publish message to topic %s.", self.shopping_cart_topic)
            raise
        else:
            return message_id


def get_topic(sns_resource, topic_arn: str) -> Any:
    topics = sns_resource.topics.all()
    for topic in topics:
        if topic.attributes["TopicArn"] == topic_arn:
            return topic
    return None


def create_shopping_cart_topic(sns_resource):
    name = "shopping_cart"
    try:
        topic = sns_resource.create_topic(Name="shopping_cart")
        logger.info("Created topic %s with ARN %s.", name, topic.arn)
    except ClientError as e:
        logger.exception("Couldn't create topic %s.", name)
        raise
    else:
        return topic
