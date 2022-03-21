import os
import boto3
import email
import re
from botocore.exceptions import ClientError
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication

region = os.environ['Region']
sender = os.environ['MailSender']
recipient = os.environ['MailRecipient']
incoming_email_bucket = os.environ['MailS3Bucket']
incoming_email_prefix = os.environ['MailS3Prefix']

client_s3 = boto3.client('s3')
client_ses = boto3.client('ses', region)

def get_s3_object_path(message_id):
    object_path = message_id

    if incoming_email_prefix:
        object_path = (incoming_email_prefix + '/' + object_path)

    object_http_path = (f'http://s3.console.aws.amazon.com/s3/object/{incoming_email_bucket}/{object_path}?region={region}')

    return (
        object_path,
        object_http_path
    )

def get_message_from_s3(message_id):
    object_path, object_http_path = get_s3_object_path(message_id)

    # Get the email object from the S3 bucket.
    object_s3 = client_s3.get_object(Bucket=incoming_email_bucket, Key=object_path)
    # Read the content of the message.
    file = object_s3['Body'].read()

    file_dict = {
        'file': file,
        'path': object_http_path
    }

    return file_dict

def delete_s3_object(message_id):
    object_path, *_ = get_s3_object_path(message_id)

    client_s3.delete_object(Bucket=incoming_email_bucket, Key=object_path)

    print(f'Deleted object {object_path}')


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

def handle_s3_event(event, context):
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

    delete_s3_object(message_id)
