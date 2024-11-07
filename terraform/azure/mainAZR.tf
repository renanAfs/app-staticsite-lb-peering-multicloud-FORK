module "network" {
 source = "./modules/network"
}

module "compute" {
 source = "./modules/compute"
  rg = module.network.rg
  vnet10 = module.network.vnet10
  vnet20 = module.network.vnet20
  snvnet10pub1a = module.network.snvnet10pub1a
  snvnet10pub1b = module.network.snvnet10pub1b
  snvnet20priv = module.network.snvnet20priv
}
