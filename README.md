# ar2pi-email-forwarder

Simple lambda function to forward emails from Route 53 domains to another recipient, which can be your personal email address.

Follow instructions as described here: https://aws.amazon.com/blogs/messaging-and-targeting/forward-incoming-email-to-an-external-destination/ 

Then use [lambda_function.py](./lambda_function.py) for the lambda function code and [email-forwarder-policy.json](./email-forwarder-policy.json) for the IAM policy.

Differences with this function being:
- adds sender, receiver and message body into the forwarded email instead of just attaching an `.eml` file
- deletes message s3 object once it's been sent
- uses python 3.9
