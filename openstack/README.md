#Openstack:
 - Existing Infrastructure :
     *  Instance is created within an already existing infrastructure.
     * Creation of instance requires existing networks, subnets, Routers.
     * The script accepts nput arguments for network name, network id, subnet id of management, server and client network
     *  The module is located at – a10-terraform/openstack/main/standalone/3NIC/existing_infra

  - New infrastructure :
     * Infrastructure is provisioned from scratch to create an instance.
     *  Custom network is created, within the network, one public and one private subnet is provisioned. Within subnet ports will be created
     *  An Router is provisioned and public subnet is added to Router
     *  A vThunder instance is provisioned with three ports on each subnets
     *  Three elastic IP's are provisioned, one for management, one for Data port and one for VIP.
     *  The module is located at - a10-terraform/openstack/main/standalone/3NIC/new_infra

QUICK START:

cd openstack/main/standalone/3NIC/new_infra(or existing_infra)
export OS_PASSWORD=<YOUR Openstack cloud password>
terraform init
terraform plan
terraform apply
