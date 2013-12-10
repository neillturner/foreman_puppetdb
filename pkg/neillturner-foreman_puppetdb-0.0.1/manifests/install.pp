# == Class: foreman_puppetdb::install
#
# Install Foreman and Puppet
#  
# this installs foreman, puppet, passenger and postgresql
#  
#
class foreman_puppetdb::install ( 
  $foreman_url,
  $server_name
  ){

  exec { 'yum -y install foreman-repo':
     command     => "yum -y -v install {$foreman_url}",
	 creates     => "/etc/yum.repos.d/foreman.repo",
     cwd         => "/tmp"
  }
  
  exec { 'yum -y install foreman-installer':
     command     => "yum -y -v install foreman-installer",
     cwd         => "/tmp",
	 creates     => "/usr/sbin/foreman-installer",
     require    =>  Exec['yum -y install foreman-repo']
  }
  
  class { 'puppetdb': 
      listen_address => "${server_name}",
      require        =>  Exec['yum -y install foreman-installer']
  }
  
  exec { 'foreman-installer':
     command     => "foreman-installer --puppet-server-storeconfigs-backend=puppetdb",
     cwd         => "/tmp",
	 timeout     => 0, 
     require    =>  Class['puppetdb']
  }

}
