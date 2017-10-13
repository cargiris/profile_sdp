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
    type   => dword,
    data   => 1,
  }
# IIS Resources
  dism { 'IIS-WebServer':
    ensure    => present,
    norestart => true,
    all       =>  true,
    require   => Dism['NetFx3'],
  }
  dism { 'NetFx3':
    ensure    => present,
    norestart => true,
    all       =>  true,
  }
  # Create Directories

  file { 'c:\\inetpub\\basic':
    ensure => 'directory'
  }

  file { 'c:\\inetpub\\basic_vdir':
    ensure => 'directory'
  }

  # Set Permissions

  acl { 'c:\\inetpub\\basic':
    permissions => [
      {'identity' => 'Administrators', 'rights' => ['full']},
    ],
  }

  acl { 'c:\\inetpub\\basic_vdir':
    permissions => [
      {'identity' => 'Administrators', 'rights' => ['full']},
    ],
  }

  # Configure IIS

  iis_application_pool { 'basic_site_app_pool':
    ensure                  => 'present',
    state                   => 'started',
    managed_pipeline_mode   => 'Integrated',
    managed_runtime_version => 'v4.0',
  }

  $iis_features = ['Web-WebServer','Web-Scripting-Tools']

  iis_feature { $iis_features:
    ensure => 'present',
  } ->

  iis_site { 'basic':
    ensure           => 'started',
    physicalpath     => 'c:\\inetpub\\basic',
    applicationpool  => 'basic_site_app_pool',
    enabledprotocols => 'https',
    bindings         => [
      {
        'bindinginformation'   => '*:80:',
        'protocol'             => 'http',
      },
    ],
    require => File['c:\\inetpub\\basic'],
  }

  iis_virtual_directory { 'vdir':
    ensure       => 'present',
    sitename     => 'basic',
    physicalpath => 'c:\\inetpub\\basic_vdir',
    require      => File['c:\\inetpub\\basic_vdir'],
  }

# 7zip installation
 file { 'C:\\Temp':
   ensure => directory,
 } ->

 class { 'staging':
   path  => 'C:\\Temp',
   owner => 'Administrator',
   group => 'Administrators',
   mode  => '0775',
 } ->
 
 staging::file { '7-Zip-16.04.exe':
  source => 'http://www.7-zip.org/a/7z1604-x64.exe',
 } ->
 
 package { '7-Zip 16.04 (x64)':
   source          => 'C:\\Temp\\profile\\7-Zip-16.04.exe',
   ensure          => installed,
   install_options => ['/S','/D=C:\\Program Files\\7-Zip'],
 }

}
