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

  file { 'C:\\Users\\costa\\Desktop\\Personal': 
    ensure => directory,
    owner  => 'costa',
    group  => 'sdpusers',
  }

  acl { 'C:\\Users\\costa\\Desktop\\Personal':
    permissions => [
      { identity => 'costa', rights => ['full'] },
      { identity => 'sdpusers', rights => ['read'] }
    ],
  }

  registry_value { 'HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\IEHarden':
    ensure => present,
    type   => dword,
    data   => 1,
  }
  registry::value { 'ShutdownReasonUI':
    key    => 'HKLM\\Software\\Policies\\Microsoft\\Windows NT\\Reliability',
    ensure => present,
    type   => dword,
    data   => 1,
  }
}
