# Definition:: tiller::config
#
#
define tiller::config (
  $config      = {},
  $environment = 'development',
  $user        = 'root',
  $group       = 'root',
  $target      = undef,
  $template    = $name,
) {
  $_target_file = "/etc/tiller/environments/${environment}.yaml"

  $_config = {
    $template => {
      target => $target,
      user   => $user,
      group  => $group,
      config => $config,
    }
  }

  file { $_target_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => inline_template('<%= @_config.to_yaml %>'),
  }
}
