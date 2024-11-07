module "network" {
 source = "./modules/network"
}

module "compute" {
 source = "./modules/compute"
 ec2_ami = "ami-0f409bae3775dc8e5"
 vpc10_id = module.network.vpc10_id
 vpc20_id = module.network.vpc20_id
 sn_vpc10_pub1a = module.network.sn_vpc10_pub1a
 sn_vpc10_pub1b = module.network.sn_vpc10_pub1b
 sn_vpc20_priv = module.network.sn_vpc20_priv
}