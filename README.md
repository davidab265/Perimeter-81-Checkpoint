# DevOps Home Assignment

This project demonstrates a complete DevOps pipeline for deploying AWS infrastructure using Terraform and Terragrunt, along with a Python script for processing and storing data.

## Project Structure

```
.
├── .github
│   └── workflows
│       └── deploy.yml
├── terraform
│   ├── main.tf
│   └── terragrunt.hcl
├── process_products.py
└── README.md
```

## Components

1. **Terraform Configuration (main.tf)**: Defines AWS resources including an S3 bucket and CloudFront distribution.
2. **Terragrunt Configuration (terragrunt.hcl)**: Manages Terraform deployment and state.
3. **Python Script (process_products.py)**: Downloads, processes, and uploads product data.
4. **GitHub Actions Workflow (deploy.yml)**: Automates infrastructure deployment and script execution.

## Setup and Deployment

1. Clone this repository.
2. Set up AWS credentials as GitHub secrets:
   - AWS_ACCESS_KEY_ID
   - AWS_SECRET_ACCESS_KEY
3. Update the `terragrunt.hcl` file with your specific S3 bucket for Terraform state.
4. Update the `process_products.py` script with your S3 bucket name. the claudfront domain will be set automatically in the pipeline and will be used automatically in the python script.
5. Push changes to the `main` branch to trigger the GitHub Actions workflow.

## Workflow Steps

1. The GitHub Actions workflow is triggered on push to the `main` branch.
2. It first deploys the infrastructure using Terraform (with the Terragrunt tool as a warper).
3. After successful infrastructure deployment, it runs the Python script.

## Python Script Functionality

The `process_products.py` script:
1. Downloads product data from https://dummyjson.com/products
2. Filters products with a price >= $100
3. Saves the filtered data to a new JSON file
4. Uploads the file to the S3 bucket
5. Downloads the file via CloudFront and verifies its integrity

## Customization

- Update `terragrunt.hcl` for different state management options.
- Adjust the Python script for different data processing requirements.

## Security Notes

- AWS credentials are stored as GitHub secrets and not in the code.
- The S3 bucket is configured to only allow access from CloudFront.

## Tags

All AWS resources are tagged with:
- Name: ProductCloudFront
- Owner: [<username>]
- Terraform: True

## Troubleshooting

If you encounter issues:
1. Check AWS credentials are correctly set in GitHub secrets.
2. Ensure all required permissions are set for the AWS user.
