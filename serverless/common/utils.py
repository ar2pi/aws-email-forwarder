import boto3

client_s3 = boto3.client('s3')

def get_s3_object_path(object, bucket, folder_prefix=None, region='us-east-1'):
    object_path = object

    if folder_prefix:
        object_path = (folder_prefix + '/' + object)

    object_http_path = (f'http://s3.console.aws.amazon.com/s3/object/{bucket}/{object_path}?region={region}')

    return (
        object_path,
        object_http_path
    )

def get_s3_object(object_path, bucket):
    return client_s3.get_object(Bucket=bucket, Key=object_path)

def delete_s3_object(object, bucket, folder_prefix=None, region='us-east-1'):
    object_path, *_ = get_s3_object_path(object, bucket, folder_prefix, region)

    client_s3.delete_object(Bucket=bucket, Key=object_path)

    print(f'Deleted object {object_path}')
