$packs = [ 'httpd', 'php', 'php-mysqlnd', 'git' ]

package { $packs:
  ensure => installed,
  provider => 'yum'
}

vcsrepo { '/code':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/shekeriev/do2-app-pack.git',
}

file { '/etc/httpd/conf.d/vhost-app1.conf':
  ensure  => present,
  content => "Listen 8081\n<VirtualHost *:8081>\n  DocumentRoot \"/var/www/app1\"\n</VirtualHost>\n",
}

file { '/etc/httpd/conf.d/vhost-app2.conf':
  ensure  => present,
  content => "Listen 8082\n<VirtualHost *:8082>\n  DocumentRoot \"/var/www/app2\"\n</VirtualHost>\n",
}

file { '/var/www/app1':
  ensure  => directory,
  recurse => true,
  source  => '/code/app1/web/',
}

file { '/var/www/app2':
  ensure  => directory,
  recurse => true,
  source  => '/code/app2/web/',
}

class { 'firewall': }

firewall { '000 accept 8081/tcp':
  action => 'accept',
  dport  => 8081,
  proto  => 'tcp',
}

firewall { '000 accept 8082/tcp':
  action => 'accept',
  dport  => 8082,
  proto  => 'tcp',
}

class { 'selinux':
  mode => 'permissive',
}

service { 'httpd':
  ensure => running,
  enable => true,
}