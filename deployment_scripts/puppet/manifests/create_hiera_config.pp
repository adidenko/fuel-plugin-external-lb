# Manifest that creates hiera config overrride
notice('MODULAR: create_hiera_config.pp')

$external_lb = hiera('external-lb')

file {'/etc/hiera/plugins/fuel-plugin-external-lb.yaml':
  ensure  => file,
  content => "# Created by puppet, please do not edit manually
network_metadata:
  vips:
    management:
      ipaddr: <%= @external_lb['management_ip'] %>
      namespace: false
    public:
      ipaddr: <%= @external_lb['public_ip'] %>
      namespace: false
    vrouter:
      ipaddr: 10.144.2.1
      namespace: false
    vrouter_pub:
      ipaddr: 10.144.1.1
      namespace: false
run_ping_checker: false
management_vrouter_vip: 10.144.2.5
"
}
