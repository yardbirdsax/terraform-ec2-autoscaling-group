# Ubuntu on EC2 with Terraform

This is a [Terraform](https://terraform.io) module that will provision one or more EC2 instances that run Ubuntu.

## Variables

| Variable Name         | Description                                                                   |
------------------------|-------------------------------------------------------------------------------|
| aws_region            | The AWS Region where resources will be deployed. Defaults to 'us-east-2'.     |
| min_instance_count    | The minimum number of EC2 instances to provision.                             |
| max_instance_count    | The maximum number of EC2 instances to provision.                             |
| desired_instance_count | The desired number of EC2 instances to provision.                            |
| keypair_path          | The path to the SSH public key file that will be used for access to the instance. |
| deployment_name       | A unique name used to generate things like the instance name.                 |
| iam_role_name         | The name of an existing IAM role to assign to the instance profile. If left blank, no role will be assigned. |
| subnet_ids            | The IDs of the subnets where the instances will be provisioned. The deployment will round-robin the instances across all the provided subnets. |
| security_group_ids    | A list of IDs of Security Groups that the instances should be assigned to.     |
| assign_public_ip      | If set to 'true', the instances will be assigned a public IP. Defaults to 'true'. |
| instance_type         | The AWS [Instance Type](https://aws.amazon.com/ec2/instance-types/) to use when provisioning the instances. Defaults to 't3.small'. |
