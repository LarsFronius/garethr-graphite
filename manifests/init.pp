class graphite(
  $admin_password = $graphite::params::admin_password,
  $port = $graphite::params::port,
) inherits graphite::params {
  anchor { 'graphite::begin':
    before => Class['graphite::install'],
    notify => Class['graphite::config']
  }

  class{'graphite::install': }
  class{'graphite::config': } ~>
  class{'graphite::service': }

  anchor { 'graphite::end':
    require => Class['graphite::config']
  }

}
