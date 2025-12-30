from kafka import KafkaProducer
import json
import pandas as pd

KAFKA_BROKER = "localhost:9092"
TOPIC_NAME = 'hw3_topic'

# Create a Kafka producer instance
# value_serializer converts the message value to bytes before sending
producer = KafkaProducer(
    bootstrap_servers=KAFKA_BROKER,
    value_serializer=lambda v: json.dumps(v).encode("utf-8"),
    linger_ms=50,   # небольшая батчинг-оптимизация
)

df = pd.read_csv('data/train.csv')
df["transaction_time"] = pd.to_datetime(df["transaction_time"], errors="coerce")
df["transaction_time"] = df["transaction_time"].dt.strftime("%Y-%m-%d %H:%M:%S")
df = df.fillna("")
# Message to send
try:
    for i, record in enumerate(df.to_dict(orient="records")):
        message = {"id": i} | record
        producer.send(TOPIC_NAME, value=message)

    producer.flush()
    print(f"Sent {len(df)} messages to topic '{TOPIC_NAME}'")

except Exception as e:
    print(f"Kafka error: {e}")

finally:
    producer.close()