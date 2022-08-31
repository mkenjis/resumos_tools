import json

def lambda_handler(event, context):
	# TODO implement
	import sys
	import boto3
	
	ec2 = boto3.resource('ec2')
	client = boto3.client('ec2', 'sa-east-1')
	
	# auxiliary variables
	curr_inst_type = ''
	default_inst_type = 't3a.medium'
	
	# Insert your Instance ID here
	my_instance = '<Instance ID>'
	
	# lookup the current instance type of Instance ID
	instances = ec2.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
	for instance in instances:
		if instance.id == my_instance:
			curr_inst_type = instance.instance_type
	
	if curr_inst_type == '':
	    curr_inst_type = default_inst_type
	
	req_inst_type = ''
	for instance in ec2.instances.filter(Filters=[{'Name': 'instance-id', 'Values': [my_instance]}]):
		tags = instance.tags
		
	if tags:
		# search for a tag REQ_INSTANCE_TYPE informing the requested instance type
		for tag in tags:
			if tag['Key'] == 'REQ_INSTANCE_TYPE':
				req_inst_type = tag['Value']
	
	# if REQ_INSTANCE_TYPE tag not found or empty, assume default_inst_type
	if (req_inst_type == ''):
	    req_inst_type = default_inst_type
			
	else:
		# checkout if tag REQ_INSTANCE_TYPE contains a valid EC2 instance type 
		e = ''
		import traceback
		try:
			client.modify_instance_attribute(InstanceId=my_instance, Attribute='instanceType', Value=req_inst_type)
		except: # catch *all* exceptions
			e = traceback.format_exc()
	
		# if REQ_INSTANCE_TYPE tag contains an invalid instance type, assume default_inst_type
		import re
		if re.search("for InstanceType", e):
		    req_inst_type = default_inst_type
			
	# otherwise, assume the instance type from REQ_INSTANCE_TYPE tag
			
	print('Default instance type = '+default_inst_type)
	print('Current instance type = '+curr_inst_type)
	print('Requested instance type = '+req_inst_type)
		
	# resize EC2 with instance type provided by tag REQ_INSTANCE_TYPE
	if (req_inst_type != curr_inst_type):
	
		# Stop the instance
		client.stop_instances(InstanceIds=[my_instance])
		waiter=client.get_waiter('instance_stopped')
		waiter.wait(InstanceIds=[my_instance])
	
		# Change the instance type
		client.modify_instance_attribute(InstanceId=my_instance, Attribute='instanceType', Value=req_inst_type)
	
		# Start the instance
		client.start_instances(InstanceIds=[my_instance])

		print('Resize sucessfully executed')
		
	else:
		print('Nothing done. Same instance type')