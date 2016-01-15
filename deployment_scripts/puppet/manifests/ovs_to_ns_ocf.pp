  $service_name = 'p_exlb_floating_port'

  $primitive_type = 'ovs_to_ns_port'
  $complex_type   = 'clone'
  $ms_metadata = {
    'interleave' => true,
  }
  $metadata = {
    'migration-threshold' => 'INFINITY',
    'failure-timeout'     => '120',
  }
  $parameters = {
    'ns'             => 'vrouter',
  }
  $operations = {
    'monitor' => {
      'interval' => '30',
      'timeout'  => '60'
    },
    'start'   => {
      'timeout' => '30'
    },
    'stop'    => {
      'timeout' => '60'
    },
  }

  service { $service_name :
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    provider   => 'pacemaker',
  }

  pacemaker_wrappers::service { $service_name :
    primitive_type => $primitive_type,
    parameters     => $parameters,
    metadata       => $metadata,
    operations     => $operations,
    ms_metadata    => $ms_metadata,
    complex_type   => $complex_type,
    prefix         => false,
  }
