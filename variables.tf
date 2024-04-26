variable "source_region" {
  description = "The source AWS region where the primary resources are located"
  default = "us-east-1"

}

variable "destination_region" {
  description = "The destination AWS region for disaster recovery"
  default = "us-east-2"

}

variable "instance_ids" {
  description = "List of EC2 instance IDs to be replicated for disaster recovery"
  default = "i-01e065d1613af3a39"
}

variable "restore" {
description = "Used to restore the jenkins server"
default  = true
}
variable "snapshot_name" {
description = "react_instance_for_disaster"
default  = true
}