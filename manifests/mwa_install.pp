# /etc/puppet/modules/munki_appliance/manifests/mwa_install.pp

class munki_appliance::mwa_install {
  $mwa_service_account  = $munki_appliance::mwa_service_account
  $munki_web_admin_dir  = $munki_appliance::munki_web_admin_dir
  $munki_web_admin_data = $munki_appliance::munki_web_admin_data
  $munki_root           = $munki_appliance::munki_root
  $time_Zone            = $munki_appliance::time_zone
  $admin_name           = $munki_appliance::admin_name
  $admin_email          = $munki_appliance::admin_email

  vcsrepo { "${munki_web_admin_dir}/munkiwebadmin" :
    ensure   => latest,
    provider => git,
    source   => 'https://code.google.com/p/munki.munkiwebadmin',
    revision => 'master',
    owner    => $mwa_service_account,
    group    => $mwa_service_account,
    require  => Package['git'],
  }

  file { "${munki_web_admin_dir}/munkiwebadmin/settings.py" :
    ensure  => present,
    group   => $mwa_service_account,
    mode    => '0644',
    owner   => $mwa_service_account,
    content => template('munki_appliance/settings.py.erb'),
    require => Vcsrepo["${munki_web_admin_dir}/munkiwebadmin"],
  }

  file { "${munki_web_admin_dir}/munkiwebadmin/createsuperuser.py" :
    ensure  => 'file',
    source  => 'puppet:///modules/munki_appliance/createsuperuser.py',
    group   => $mwa_service_account,
    mode    => '0644',
    owner   => $mwa_service_account,
    require => Vcsrepo["${munki_web_admin_dir}/munkiwebadmin"],
  }

  file { "${munki_web_admin_dir}/munkiwebadmin/doesuserexist.py" :
    ensure  => 'file',
    source  => 'puppet:///modules/munki_appliance/doesuserexist.py',
    group   => $mwa_service_account,
    mode    => '0644',
    owner   => $mwa_service_account,
    require => Vcsrepo["${munki_web_admin_dir}/munkiwebadmin"],
  }
}