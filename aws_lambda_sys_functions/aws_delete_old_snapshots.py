# Delete snapshots older than retention period

import boto3
from botocore.exceptions import ClientError

from datetime import datetime,timedelta


def delete_snapshot(snapshot_id, reg):
    print ("Deleting snapshot %s ", snapshot_id)
    try:  
        ec2resource = boto3.resource('ec2', region_name=reg)
        snapshot = ec2resource.Snapshot(snapshot_id)
        snapshot.delete()

    except ClientError as e:
        print ("Caught exception: %s", e)
        
    return
    
def lambda_handler(event, context):
    
    # Get current timestamp in UTC
    now = datetime.now()

    # AWS Account ID 
    account_id = '<Account ID >'
    
    # Define retention period in days
    retention_days = 7
    
    # Create EC2 client
    ec2 = boto3.client('ec2')
    
    reg='sa-east-1'
    print ("Checking region %s ", reg )
        
    # Connect to region
    ec2 = boto3.client('ec2', reg)
    
    # Filtering by snapshot timestamp comparison is not supported
    # So we grab all snapshot id's
    result = ec2.describe_snapshots( OwnerIds=[account_id] )
    snapshots = result['Snapshots']
    snap_sorted = sorted(snapshots, key=lambda d: d['StartTime'])

    for snapshot in snap_sorted:
        
        # Remove timezone info from snapshot in order for comparison to work below
        snapshot_time = snapshot['StartTime'].replace(tzinfo=None)
        
        # If snapshot_time is older than retention_days, skip it because snapshot is not deletable.
        if (snapshot_time < now - timedelta(retention_days+5)):
            continue
        
        print ("Checking snapshot ",snapshot['SnapshotId']," which was created on ",snapshot['StartTime'])
        
        # Subtract snapshot time from now returns a timedelta 
        # Check if the timedelta is greater than retention days
        if (now - snapshot_time) > timedelta(retention_days):
            print ("Snapshot is older than configured retention of ",retention_days," days")
            delete_snapshot(snapshot['SnapshotId'], reg)
        else:
            break;
            # print ("Snapshot is newer than configured retention of ",retention_days," days so we keep it")

