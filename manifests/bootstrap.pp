# Define: tiller::bootstrap
#
#
define tiller::bootstrap (
  $development_config = {},
  $staging_config     = {},
  $production_config  = {},
  $user               = 'root',
  $group              = 'root',
  $target             = undef,
  $template           = $name,
  $source             = undef,
) {
  include ::tiller

  tiller::template { $template:
    source => $source,
  }

  validate_hash($development_config)
  tiller::config { "${template}-development":
    template    => $template,
    environment => 'development',
    config      => $development_config,
    user        => $user,
    group       => $group,
    target      => $target,
  }
  validate_hash($staging_config)
  tiller::config { "${template}-staging":
    template    => $template,
    environment => 'staging',
    config      => $staging_config,
    user        => $user,
    group       => $group,
    target      => $target,
  }
  validate_hash($production_config)
  tiller::config { "${template}-production":
    template    => $template,
    environment => 'production',
    config      => $production_config,
    user        => $user,
    group       => $group,
    target      => $target,
  }
}
