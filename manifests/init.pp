# == Class: tiller
#
#
class tiller(
  $api                 = false,
  $api_port            = 3000,
  $run                 = [],
  $data_sources        = [
    'defaults',
    'file',
    'environment',
  ],
  $default_environment = 'development',
  $template_sources    = [
    'file',
  ],
) {
  validate_bool($api)
  validate_integer($api_port)
  validate_array($run, $data_sources, $template_sources)
  $_root_dir = '/etc/tiller'

  package { 'tiller':
    ensure   => present,
    provider => 'gem',
  }
  file { [$_root_dir,
    "${_root_dir}/environments",
    "${_root_dir}/templates",
    ]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  $_common_config = {
    data_sources        => $data_sources,
    template_sources    => $template_sources,
    default_environment => $default_environment,
    exec                => join($run, ' '),
  }
  if $api {
    $_api_config = {
      common => {
        api_enable => $api,
        api_port   => $api_port,
      }
    }
  } else { $_api_config = {} }

  $_config = merge($_common_config, $_api_config)
  file { '/etc/tiller/common.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => inline_template('<%= @_config.to_yaml %>'),
  }

  $_hiera_templates = hiera_hash('tiller::templates', {})
  $_hiera_configs = hiera_hash('tiller::configs', {})
  $_hiera_bootstraps = hiera_hash('tiller::bootstraps', {})
  create_resources('tiller::template', $_hiera_templates)
  create_resources('tiller::config', $_hiera_configs)
  create_resources('tiller::bootstraps', $_hiera_bootstraps)
}
