# /etc/puppetlabs/code/environments/<#ENVIRONMENT>/profile/manifests/mysql/master.pp
class profile::windows {

  group { 'sdpusers':
    ensure => present,
    gid    => '111',
  }

  user { 'costa':
    ensure  => present,
    gid     => '111', 
    require => Group['sdpusers'],
  }
}
