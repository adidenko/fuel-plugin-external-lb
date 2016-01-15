# Manifest that creates hiera config overrride
notice('MODULAR: external_loadbalancer/create_hiera_config.pp')

$plugin_name    = 'external_loadbalancer'
$external_lb    = hiera("$plugin_name")
$network_scheme = hiera_hash("network_scheme", {})
$floating_br    = pick($network_scheme['roles']['neutron/floating'], 'br-floating')
$floating_gw_if = pick($external_lb['floating_gw_if'], 'exlb-float-gw')

file {"/etc/hiera/plugins/${plugin_name}.yaml":
  ensure  => file,
  content => inline_template("# Created by puppet, please do not edit manually
network_metadata:
  vips:
    management:
      ipaddr: <%= @external_lb['management_ip'] %>
      namespace: false
    public:
      ipaddr: <%= @external_lb['public_ip'] %>
      namespace: false
run_ping_checker: false
<% if @external_lb['enable_fake_floating'] -%>
quantum_settings:
  predefined_networks:
    admin_floating_net:
      L3:
        subnet: <%= @external_lb['fake_floating_cidr'] %>
        floating:
        - <%= @external_lb['fake_floating_range'] %>
        gateway: <%= @external_lb['fake_floating_gw'] %>
network_scheme:
  transformations:
  - action: add-port
    name: <%= @floating_gw_if %>
    bridge: <%= @floating_br %>
    provider: ovs
<% end -%>
")
# ip link set exlb-float-gw netns vrouter
# ip netns exec vrouter ip a add 10.10.10.1/24 dev exlb-float-gw
}
