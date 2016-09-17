class build::php55 {
  require build::php55::packages
  require build::php55::supervisor
  require build::phpfarm
  require build::freetds

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.5.38/etc/conf.d': }

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.5.38/etc/fpm.d': }

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.5.38/etc/pool.d': }

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.5.38/lib/php/extensions/no-debug-non-zts-20121212': }

  file { '/tmp/php-5.5.38.tar.gz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/php-5.5.38.tar.gz'
  }

  bash_exec { 'cd /tmp && tar xzf php-5.5.38.tar.gz':
    require => File['/tmp/php-5.5.38.tar.gz']
  }

  bash_exec { 'mv /tmp/php-5.5.38 /usr/local/src/phpfarm/src/php-5.5.38':
    require => Bash_exec['cd /tmp && tar xzf php-5.5.38.tar.gz']
  }

  file { '/usr/local/src/phpfarm/src/custom/options-5.5.38.sh':
    ensure => present,
    source => 'puppet:///modules/build/usr/local/src/phpfarm/src/custom/options-5.5.38.sh',
    mode => 755,
    require => Bash_exec['mv /tmp/php-5.5.38 /usr/local/src/phpfarm/src/php-5.5.38']
  }

  bash_exec { '/usr/local/src/phpfarm/src/main.sh 5.5.38':
    timeout => 0,
    require => File['/usr/local/src/phpfarm/src/custom/options-5.5.38.sh']
  }

  bash_exec { 'rm -rf /usr/local/src/phpfarm/src/php-5.5.38':
    require => Bash_exec['/usr/local/src/phpfarm/src/main.sh 5.5.38']
  }

  file { '/usr/local/src/phpfarm/inst/php-5.5.38/etc/php-fpm.conf':
    ensure => present,
    source => 'puppet:///modules/build/usr/local/src/phpfarm/inst/php-5.5.38/etc/php-fpm.conf',
    mode => 644,
    require => Bash_exec['/usr/local/src/phpfarm/src/main.sh 5.5.38']
  }

  bash_exec { 'switch-phpfarm 5.5.38':
    require => Bash_exec['/usr/local/src/phpfarm/src/main.sh 5.5.38']
  }
}
