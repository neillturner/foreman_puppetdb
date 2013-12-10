# == Class: foreman_puppetdb::prereqs
#
# this installs and setups the prereqs for installing foreman and puppet  
#  
#
class foreman_puppetdb::prereqs (
   $epel_url,
   $epel
   ){
   
   class { 'selinux':
       mode => 'disabled'
    }
   
   # required to download epel
   package { wget:
      ensure => installed,
	  require    =>  Class['selinux']
   }
   
   # required to be run if you wish to re-install without starting with a clean server.
   # unfortunately the install is not idempotent   
   file { "/root/clean.sh":
     ensure => "file",
	 owner => 'root',
     group => 'root',
     mode => 755,
	 source  => 'puppet:///modules/foreman_puppetdb/clean.sh',
   }
   
   # required by foreman installer dependencies 
   exec {'download epel repo':
     command     => "wget ${epel_url}",
     cwd         => "/tmp",
    creates     => "/tmp/${epel}",
     require    =>  Package['wget']
   }  

   exec {'install epel repo':
     command     => "rpm -Uvh ${epel}",
     cwd         => "/tmp",
	 creates     => "/etc/yum.repos.d/epel.repo",
     require    =>   Exec['download epel repo']
   } 

   # required to fix bug with java 1.6 that causes error: Failed to submit 'replace facts' command
   package { 'java-1.7.0-openjdk' : 
      ensure => installed,
	  require    =>    Class ['selinux']
	}
      
   
  } 