## VPC Module Example

This example demonstrates the usage of the VPC module to create a custom VPC with private and public subnets in AWS.

### Prerequisites

- Terraform installed on your local machine.
- AWS credentials configured.

### Usage

1. Clone this repository to your local machine.

2. Navigate to the directory where your Terraform code is located.

3. Create a new Terraform configuration file (e.g., `main.tf`) and copy the following code into it:

```hcl
module "vpc" {
  source = "./terraform-aws-vpc"

  name             = "myvpc"
  vpc_cidr_block   = "10.183.0.0/16"
  region           = "us-west-2"

  private_subnets = [
    {
      cidr_block        = "10.183.0.0/20"
      availability_zone = "us-west-2a"
    },
    {
      cidr_block        = "10.183.16.0/20"
      availability_zone = "us-west-2b"
    },
    {
      cidr_block        = "10.183.32.0/20"
      availability_zone = "us-west-2c"
    }
  ]

  public_subnets = [
    {
      cidr_block        = "10.183.128.0/20"
      availability_zone = "us-west-2a"
    },
    {
      cidr_block        = "10.183.144.0/20"
      availability_zone = "us-west-2b"
    },
    {
      cidr_block        = "10.183.160.0/20"
      availability_zone = "us-west-2c"
    }
  ]
}
```

4. Run the following commands in the directory containing your Terraform code:

```shell
terraform init
terraform apply
```

5. Review the changes that will be applied and confirm by entering `yes`.

6. Wait for Terraform to provision the VPC and its associated resources.

7. After the deployment is complete, you can access the output values by running:

```shell
terraform output
```

### Inputs

The following input variables can be configured for the VPC module:

- `name`: The name of the VPC.
- `vpc_cidr_block`: The CIDR block for the VPC.
- `region`: The AWS region where the VPC will be created.
- `private_subnets`: A list of objects representing the private subnet CIDR blocks and availability zones.
- `public_subnets`: A list of objects representing the public subnet CIDR blocks and availability zones.

### Outputs

The VPC module provides the following outputs:

- `vpc_id`: The ID of the created VPC.
- `private_subnet_ids`: The IDs of the private subnets.
- `public_subnet_ids`: The IDs of the public subnets.
- `private_route_table_ids`: The IDs of the private route tables.
- `public_route_table_ids`: The IDs of the public route tables.
- `nat_gateway_ids`: The IDs of the NAT gateways.
- `dynamodb_endpoint_id`: The ID of the DynamoDB VPC endpoint.
- `s3_endpoint_id`: The ID of the S3 VPC endpoint.

### Clean Up

To clean up and destroy the created resources, run the following command:

```shell
terraform destroy
```

Confirm the destruction by entering `yes`.

Remember to clean up any other resources that were created externally but are not managed by Terraform.
