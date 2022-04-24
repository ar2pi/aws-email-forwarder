import os
import email
import boto3
from botocore.exceptions import ClientError
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from common.utils import get_s3_object_path, get_s3_object, delete_s3_object

region = os.environ('AWS_REGION')
sender = os.environ['MAIL_SENDER']
recipient = os.environ['MAIL_RECIPIENT']
incoming_email_bucket = os.environ['MAIL_S3_BUCKET']
incoming_email_folder = os.environ['MAIL_S3_FOLDER']

client_ses = boto3.client('ses', region)

def get_message_from_s3(message_id):
    object_path, object_http_path = get_s3_object_path(object=message_id, bucket=incoming_email_bucket, folder_prefix=incoming_email_folder, region=region)

    # Get the email object from the S3 bucket.
    object_s3 = get_s3_object(object_path=object_path, bucket=incoming_email_bucket)
    # Read the content of the message.
    file = object_s3['Body'].read()

    file_dict = {
        'file': file,
        'path': object_http_path
    }

    return file_dict


def create_message(file_dict):
    # Parse the email body.
    mailobject = email.message_from_string(file_dict['file'].decode('utf-8'), policy=email.policy.default)

    # Create a new subject line.
    subject = mailobject['Subject']

    msg_body = mailobject.get_body(('html', 'plain'))
    if msg_body:
        msg_body = msg_body.get_content()

    body_text = (
        '<b>FROM:</b> ' + mailobject['From'].replace('<', '(').replace('>', ')') + '<br>'
        + '<b>TO:</b> ' + mailobject['To'].replace('<', '(').replace('>', ')') + '<br>'
        + '<b>BODY:</b><br><br>'
        + msg_body
    )

    # Create a MIME container.
    msg = MIMEMultipart()
    # Create a MIME text part.
    text_part = MIMEText(body_text, _subtype='html')
    # Attach the text part to the MIME message.
    msg.attach(text_part)

    # Add subject, from and to lines.
    msg['Subject'] = subject
    msg['From'] = sender
    msg['To'] = recipient

    message = {
        'Source': sender,
        'Destinations': recipient,
        'Data': msg.as_string()
    }

    return message

def send_email(message):
    # Send the email.
    try:
        #Provide the contents of the email.
        response = client_ses.send_raw_email(
            Source=message['Source'],
            Destinations=[
                message['Destinations']
            ],
            RawMessage={
                'Data':message['Data']
            }
        )

    # Display an error if something goes wrong.
    except ClientError as e:
        output = e.response['Error']['Message']
    else:
        output = 'Email sent! Message ID: ' + response['MessageId']

    return output

def lambda_handler(event, context):
    # Get the unique ID of the message. This corresponds to the name of the file
    # in S3.
    message_id = event['Records'][0]['ses']['mail']['messageId']
    print(f'Received message ID {message_id}')

    # Retrieve the file from the S3 bucket.
    file_dict = get_message_from_s3(message_id)

    # Create the message.
    message = create_message(file_dict)

    # Send the email and print the result.
    result = send_email(message)
    print(result)

    delete_s3_object(object=message_id, bucket=incoming_email_bucket, folder_prefix=incoming_email_folder, region=region)
