import json

def lambda_handler(event, context):
    # TODO implement
    import sys
    import boto3
    
    ec2 = boto3.resource('ec2')
    client = boto3.client('ec2', 'sa-east-1')
    
    # Insert your Instance ID here
    my_instance = '<Instance ID>'

    # Set instance type
    from datetime import date
    today = date.today()
    dom = int(today.strftime("%d"))
    if (dom in range(1,10)):
        doy = today.strftime("%d/%m")
        if (doy in ['01/01','21/04','01/05','07/09','12/10','02/11','15/11','20/11','25/12']):   # holidays
            inst_type = 't3a.medium'
        else:
            inst_type = 'c5a.xlarge'
    else:
        inst_type = 'c5a.large'
        
    response = client.create_tags(Resources=[my_instance], Tags=[{'Key':'REQ_INSTANCE_TYPE', 'Value':inst_type}])
    
    if response['ResponseMetadata']['HTTPStatusCode']==200:
        print('Successful')
    else:
        print('Unsuccessful')