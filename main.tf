// Provider configuration
terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
 }
}
 
provider "aws" {
 region = "us-east-1"
}

resource "aws_instance" "reactapplication" {
 ami           = "ami-0cd59ecaf368e5ccf"
 instance_type = "t2.micro"
}


# Get Existing Instance ID (replace with your actual instance ID)
data "aws_instance" "primary_instance" {
  id = "i-01e065d1613af3a39"

}



# Resource to store the latest snapshot ID
resource "aws_data_snapshot" "latest_snapshot" {
  filters = {
    owner_id = aws_instance.primary_instance.owner_id
    volume_id = aws_instance.primary_instance.volume_ids[0]
  }

  most_recent = true
}

# Define a variable for the target Availability Zone in the disaster region
variable "disaster_az" {
  type = string
  default = "us-east-2"
}

# Resource to restore the EBS snapshot in the disaster region
resource "aws_snapshot_copy" "disaster_recovery_snapshot" {
  source_region  = aws_instance.primary_instance.region
  source_snapshot_id = aws_data_snapshot.latest_snapshot.id
  destination_region = var.disaster_az

  copy_tags = true
}


# Launch a new instance from the restored snapshot (manual process)

# You can use the aws_instance resource with the following details:
# - ami = aws_snapshot_copy.disaster_recovery_snapshot.id (replace AMI with the actual ID)
# - instance_type = aws_instance.primary_instance.instance_type
# - security_group = aws_instance.primary_instance.vpc_security_group_ids[0]
# - subnet_id = select(1, aws_instance.primary_instance.subnet_ids)  # Choose a subnet in the disaster AZ

# Remember to configure user data, network settings etc. as needed for your application.