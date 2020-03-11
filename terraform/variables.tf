variable aws_region {
    type = string
    default = "us-east-2"
}

variable min_instance_count {
    type = number
    default = 1
    description = "The minimum number of instances to provision."
}

variable max_instance_count {
    type = number
    default = 1
    description = "The maximum number of instances to provision."
}

variable desired_instance_count {
    type = number
    default = 1
    description = "The desired number of instances."
}

variable keypair_path {
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable keypair_content {
    type = string
    default = ""
    description = "The content that will be used to create the SSH keypair in AWS. If specified will ignore the value of the `keypair_path` variable."
}

variable deployment_name {
    type = string
    description = "A unique name used to generate other names for resources, such as instance names."
}

variable iam_role_name {
    type = string
    default = ""
    description = "The name of an IAM Role to assign to the instance. If left blank, no role will be assigned."
}

variable subnet_ids {
    type = list(string)
    default = []
    description = "The IDs of the VPC subnets to assign the instance to. The deployment will round robin the instance placement across the provided subnets."
}

variable security_group_ids {
    type = list(string)
    default = ["default"]
    description = "A list of Security Group IDs to assign to the instances. If left blank, none will be assigned."
}

variable assign_public_ip {
    type = bool
    default = true
    description = "If set to 'true', a public IP address will be assigned to the instances."
}

variable instance_type {
    type = string
    default = "t3.small"
    description = "The AWS EC2 Instance Type to provision the instances as."
}