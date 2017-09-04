# /etc/puppetlabs/code/environments/<#ENVIRONMENT>/profile/manifests/mysql/master.pp
class profile::mysql {

  $mysql_root_passwd = lookup('profile::mysql::root_password')
  $mysql_dbs = lookup('profile::mysql::mysql_dbs', Hash, 'deep', {})

  class { '::mysql::server':
    root_password           => $mysql_root_passwd,
    remove_default_accounts => false,
  }
  
  create_resources('::mysql::db',$mysql_dbs)
}
