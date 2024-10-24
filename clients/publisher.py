from utils.Client import ClientFactory
from time import sleep
from env import Config

config = Config()

TOPIC="random/topic"
PORT=8883
ID="ID-PUB"

client = ClientFactory(id=ID,topic=TOPIC,username=config.BROKER_USERNAME,password=config.BROKER_PASSWORD,ca=config.CA_PATH)
client.connect(config.BROKER_FQDN,PORT)


for i in range(5):
    client.publish(TOPIC,f"message number {i}")
    sleep(1)
    