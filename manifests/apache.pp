# /etc/puppetlabs/code/environments/<#ENVIRONMENT>/profile/manifests/apache/master.pp
class profile::apache {

  class { '::apache':
    default_vhost => false,
    servername => 'nix_sdp',
  }
   
  $apache_vhosts = lookup('profile::apache::vhosts', Hash, 'hash', {})

  create_resources('::apache::vhost',$apache_vhosts)
}
