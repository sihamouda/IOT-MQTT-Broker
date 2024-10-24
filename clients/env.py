import os 

class Config:
    def __init__(self):
        try:
            self.BROKER_FQDN = os.getenv("BROKER_FQDN")
            if self.BROKER_FQDN == None:
                raise Exception("Empty BROKER_FQDN")
        except:
            self.BROKER_FQDN = "mosquitto"
            self.BROKER_FQDN = "localhost"

        try:
            self.BROKER_USERNAME = os.getenv("BROKER_USERNAME")
            if self.BROKER_USERNAME == None:
                raise Exception("Empty BROKER_USERNAME")
        except:
            self.BROKER_USERNAME = "admin"

        try:
            self.BROKER_PASSWORD = os.getenv("BROKER_PASSWORD")
            if self.BROKER_PASSWORD == None:
                raise Exception("Empty BROKER_PASSWORD")
        except:
            self.BROKER_PASSWORD = "admin"

        try:
            self.IS_TLS = os.getenv("IS_TLS").lower() == "true"
            if self.IS_TLS == None:
                raise Exception("Empty IS_TLS")
        except:
            self.IS_TLS = True

        try:
            self.CA_PATH = os.getenv("CA_PATH")
            if self.CA_PATH == None:
                raise Exception("Empty CA_PATH")
        except:
            # CA_PATH = '/certs/ca.crt'
            self.CA_PATH = '/home/anis/IOT-MQTT-Broker/certs/ca.crt'
    