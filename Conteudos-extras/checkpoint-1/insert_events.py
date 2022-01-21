from fake_web_events import Simulation
import boto3
import json

client = boto3.client('firehose', region_name='us-east-1')

def put_record(event):
    data = json.dumps(event) + "\n"
    response = client.put_record(
        DeliveryStreamName='egd-diego',
        Record={"Data": data}
    )
    print(event)
    return response


simulation = Simulation(user_pool_size=100, sessions_per_day=100000)
events = simulation.run(duration_seconds=300)

for event in events:
    put_record(event)
