variable "vpc10_id" {}
variable "vpc20_id" {}
variable "sn_vpc10_pub1a" {}
variable "sn_vpc10_pub1b" {}
variable "sn_vpc20_priv" {}
variable "ec2_ami" {
   type    = string
   default = "ami-02e136e904f3da870"
   validation {
       condition = (
           length(var.ec2_ami) > 4 &&
           substr(var.ec2_ami, 0, 4) == "ami-"
       )
       error_message = "The valor da variável ec2_ami deve iniciar com \"ami-\"."
   }
}