import json

def lambda_handler(event, context):
    # TODO implement
	# TODO implement
	import sys
	import boto3

	ec2 = boto3.resource('ec2')

	# auxiliary variables
	curr_inst_type = ''
	default_inst_type = 't3a.medium'

	# Insert your Instance ID here
	my_instance = '<Instance ID>'

	# lookup the instance type of Instance ID
	instances = ec2.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
	for instance in instances:
		if instance.id == my_instance:
			curr_inst_type = instance.instance_type
			
	print('Default instance type = '+default_inst_type)
	print('Current instance type = '+(default_inst_type if curr_inst_type == '' else curr_inst_type))
		
	# do nothing in case instance is stopped or instance type is the same as default_inst_type
	if (curr_inst_type == '' or curr_inst_type == default_inst_type):
		print('Nothing done. Same instance type')
		return

	client = boto3.client('ec2', 'sa-east-1')

	# Stop the instance
	client.stop_instances(InstanceIds=[my_instance])
	waiter=client.get_waiter('instance_stopped')
	waiter.wait(InstanceIds=[my_instance])

	# Change the instance type
	client.modify_instance_attribute(InstanceId=my_instance, Attribute='instanceType', Value=default_inst_type)

	# Start the instance
	client.start_instances(InstanceIds=[my_instance])

	print('Downsized sucessfully to '+default_inst_type)