import json
import boto3
import requests
import os
from botocore.exceptions import ClientError

def main():
    # Get the CloudFront domain from the environment variable
    cloudfront_domain = os.environ.get('CLOUDFRONT_DOMAIN')
    print(f"CloudFront domain: {cloudfront_domain}")
    if not cloudfront_domain:
        print("CloudFront domain not found in environment variables")
        return

    url = "https://dummyjson.com/products"
    response = requests.get(url)
    response.raise_for_status()
    data = response.json()

    filtered_products = [p for p in data.get('products', []) if p.get('price', 0) >= 100]

    filename = "filtered_products.json"
    with open(filename, 'w') as f:
        json.dump(filtered_products, f, indent=2)

    bucket_name = "david-abrams-checkpoint"
    s3 = boto3.client('s3')
    try:
        s3.upload_file(filename, bucket_name, filename)
        print("File uploaded successfully to S3")
    except ClientError as e:
        print(f"Failed to upload to S3: {e}")
        return

    cloudfront_url = f"https://{cloudfront_domain}/{filename}"
    downloaded_filename = f"downloaded_{filename}"
    response = requests.get(cloudfront_url)
    response.raise_for_status()
    with open(downloaded_filename, 'wb') as f:
        f.write(response.content)

    with open(filename, 'rb') as f1, open(downloaded_filename, 'rb') as f2:
        if f1.read() == f2.read():
            print("File downloaded and verified successfully from CloudFront")
        else:
            print("File verification failed")

if __name__ == "__main__":
    main()