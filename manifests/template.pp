# Definition: tiller::template
#
#
define tiller::template(
  $source,
) {
  file { "/etc/tiller/templates/${name}":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    source => $source,
  }
}
