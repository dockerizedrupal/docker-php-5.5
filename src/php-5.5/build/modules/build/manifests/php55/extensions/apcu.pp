class build::php55::extensions::apcu {
  require build::php55

  file { '/tmp/apcu-4.0.7.tgz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/apcu-4.0.7.tgz'
  }

  bash_exec { 'cd /tmp && tar xzf apcu-4.0.7.tgz':
    require => File['/tmp/apcu-4.0.7.tgz']
  }

  bash_exec { 'cd /tmp/apcu-4.0.7 && phpize-5.5.38':
    require => Bash_exec['cd /tmp && tar xzf apcu-4.0.7.tgz']
  }

  bash_exec { 'cd /tmp/apcu-4.0.7 && ./configure --with-php-config=/usr/local/src/phpfarm/inst/bin/php-config-5.5.38':
    timeout => 0,
    require => Bash_exec['cd /tmp/apcu-4.0.7 && phpize-5.5.38']
  }

  bash_exec { 'cd /tmp/apcu-4.0.7 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/apcu-4.0.7 && ./configure --with-php-config=/usr/local/src/phpfarm/inst/bin/php-config-5.5.38']
  }

  bash_exec { 'cd /tmp/apcu-4.0.7 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/apcu-4.0.7 && make']
  }
}
