provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = ""
  pm_password     = ""
  pm_user         = ""
  pm_otp          = ""
  pm_timeout      = 1000
}

resource "proxmox_node_network" "proxmox_bridge" {
  type  = "bridge" #type of bridge: linux bridge, OVS bridge etc.
  node  = ""
  iface = "" #name of the bridge
}
