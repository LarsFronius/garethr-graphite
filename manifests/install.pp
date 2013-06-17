class graphite::install {

  package {[
    'python-ldap',
    'python-cairo',
    'python-django',
    'python-twisted',
    'python-django-tagging',
    'python-simplejson',
    'libapache2-mod-python',
    'python-memcache',
    'python-pysqlite2',
    'python-support',
    'python-pip',
  ]:
  }

  #pip freeze does not show carbon and graphite-web in package list, do this to ensure it does not get installed over and over by puppet
  exec { 'install-carbon':
    command => 'pip install carbon',
    creates => '/opt/graphite/lib/carbon',
    require => Package['python-twisted','python-pip'],
  }

  exec { 'install-graphite-web':
    command => 'pip install graphite-web',
    creates => '/opt/graphite/webapp/graphite',
    require => Package['python-twisted','python-pip'],
  }

  package { 'whisper':
    ensure   => installed,
    provider => pip,
    require => Package['python-twisted','python-pip'],
  }

  file { '/var/log/carbon':
    ensure => directory,
    owner  => www-data,
    group  => www-data,
  }

  file {'/var/lib/graphite':
    ensure => directory,
    owner  => www-data,
    group  => www-data,
  }

  file {'/var/lib/graphite/db.sqlite3':
    ensure => present,
    owner  => www-data,
    group  => www-data,
  }

  class { 'apache': }

}
