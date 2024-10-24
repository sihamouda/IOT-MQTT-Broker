from utils.Client import ClientFactory
from env import Config

config = Config()

TOPIC="random/topic"
PORT=8883
ID="ID-SUB"

client = ClientFactory(id=ID,topic=TOPIC,username=config.BROKER_USERNAME,password=config.BROKER_PASSWORD,ca=config.CA_PATH)
client.connect(config.BROKER_FQDN,PORT)

client.loop_forever()