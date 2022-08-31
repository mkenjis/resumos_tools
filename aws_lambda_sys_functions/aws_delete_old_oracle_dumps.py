import json

def lambda_handler(event, context):
    # TODO implement
    import datetime
    from datetime import date
    sixmonthslater = date.today() - datetime.timedelta(days=60)
    oneyearlater = date.today() - datetime.timedelta(days=400)
    bucket_name = '<bucket>'

    import boto3
    s3 = boto3.client('s3')
    response = s3.list_objects_v2(Bucket=bucket_name)
    objects = response['Contents']

    for obj in objects:
        vdate = obj["LastModified"].date()
        vkey = obj["Key"]
        if (vkey.find('SHORT_TERM')>=0) and (vdate < sixmonthslater):
            print('Deleted ',vdate,' ',vkey,' ',vkey.find('SHORT_TERM'))
            s3.delete_object(Bucket=bucket_name, Key=vkey)
		
    for obj in objects:
        vdate = obj["LastModified"].date()
        vkey = obj["Key"]
        if (vkey.find('LONG_TERM')>=0) and (vdate < oneyearlater):
            print(vdate,' ',vkey,' ',vkey.find('LONG_TERM'))
            s3.delete_object(Bucket=bucket_name, Key=vkey)
