provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

module "vpc" {
  source = "./vpc"
}

module "security_groups" {
  source = "./security_groups"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  public_subnet_cidr_block = tolist(module.vpc.public_instance_cidr_block)
}

# module "Nacls" {
#   source = "./Nacl's"
#   vpc_id = module.vpc.vpc_id
#   public_subnet_ids  = module.vpc.public_subnet_ids
#   public_subnet_cidr_block = tolist(module.vpc.public_instance_cidr_block)
#   private_subnet_ids = module.vpc.private_subnet_ids
#   default_network_acl_id = module.vpc.default_network_acl_id
#   private_subnet_cidr_block = tolist(module.vpc.private_instance_cidr_block)
# }

module "Route_Tables" {
    source = "./Route_Tables"
    Availability_Zone = module.vpc.Availability_Zone
    vpc_id = module.vpc.vpc_id
    internet_gateway_id = module.vpc.internet_gateway_id
    public_subnet_ids  = module.vpc.public_subnet_ids
    private_subnet_ids = module.vpc.private_subnet_ids
}

/*module "Launch_Template" {
  source = "./Launch_Template"
  public_subnet_ids  = module.vpc.public_subnet_ids
  public_security_group_id  = module.security_groups.public_security_group
  private_security_group_id =   module.security_groups.private_security_group
}

module "Elastic_Load_Balancer" {
  source = "./Elastic_Load_Balancer"
  public_subnet_ids  = module.vpc.public_subnet_ids
  public_security_group_id  = module.security_groups.public_security_group
  vpc_id = module.vpc.vpc_id
  Availability_Zone =module.vpc.Availability_Zone
}

module "ASG" {
  source = "./Auto_Scaling_Group"
  launch_template_id = module.Launch_Template.launch_template_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  Load_Balancer_name = module.Elastic_Load_Balancer.My-Load_Balancer_name
}*/

module "my-Webserver" {
    source = "./server"
    public_subnet_ids  = module.vpc.public_subnet_ids
    private_subnet_ids = module.vpc.private_subnet_ids
    vpc_id = module.vpc.vpc_id
    public_subnet_cidr_block = tolist(module.vpc.public_instance_cidr_block)
    public_security_group_id  = module.security_groups.public_security_group
    private_security_group_id =   module.security_groups.private_security_group
}

