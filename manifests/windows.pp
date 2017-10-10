# /etc/puppetlabs/code/environments/<#ENVIRONMENT>/profile/manifests/mysql/master.pp
class profile::windows {

  $costa_passwd = lookup('profile::windows::costa_passwd')

  group { 'sdpusers':
    ensure => present,
  }

  user { 'costa':
    ensure   => present,
    password => $costa_passwd,
    groups   => ["Administrators","sdpusers"], 
    require  => Group['sdpusers'],
  }
  
  windows_utensils::policy_set_privilege { 'costa':
   identity    => "windows\costa",
   privilege   => "SeServiceLogonRight",
   description => "Costa user allow SeServiceLogonRight"
  }
}
