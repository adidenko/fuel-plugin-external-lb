# Manifest that creates hiera config overrride
notice('MODULAR: create_hiera_config.pp')

$external_lb = hiera('external_lb')

file {'/etc/hiera/plugins/external_lb.yaml':
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
")
}
