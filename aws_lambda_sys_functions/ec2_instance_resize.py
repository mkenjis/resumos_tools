import boto3

client = boto3.client('ec2')

# Insert your Instance ID here
my_instance = '<Instance ID>'

# Stop the instance
client.stop_instances(InstanceIds=[my_instance])
waiter=client.get_waiter('instance_stopped')
waiter.wait(InstanceIds=[my_instance])

# Change the instance type
client.modify_instance_attribute(InstanceId=my_instance, Attribute='instanceType', Value='t2.nano')

# Start the instance
client.start_instances(InstanceIds=[my_instance])