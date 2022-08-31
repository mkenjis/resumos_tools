import json

def lambda_handler(event, context):
    # TODO implement
    import datetime
    from datetime import date
    sixmonthslater = date.today() - datetime.timedelta(days=60)
    bucket_name = '<bucket>'

    import boto3
    s3 = boto3.client('s3')
    response = s3.list_objects_v2(Bucket=bucket_name)
    objects = response['Contents']
    obj_sorted = sorted(objects, key=lambda d: d['LastModified'])

    for obj in obj_sorted:
        vdate = obj["LastModified"].date()
        vkey = obj["Key"]
        if (vdate < sixmonthslater):
            print('Deleted ',vdate,' ',vkey)
            s3.delete_object(Bucket=bucket_name, Key=vkey)