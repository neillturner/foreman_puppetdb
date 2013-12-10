# == Class: foreman_puppetdb::puppet_database
#
# this configures the puppet db 
#  
#
class foreman_puppetdb::puppet_database (
  $server_name 
  ){
 
 #  this get a dependency cycle so doing the details instead of calling the class.   
 #  class { 'puppetdb::master::config':
 #    require        => Class['puppetdb']
 #  }
 # as per http://docs.puppetlabs.com/puppetdb/latest/connect_puppet_master.html
 # connect puppetdb to puppet and restart 
 
   package { 'puppetdb-terminus' : 
      ensure => installed
	}
	
	file { "/etc/puppet/puppetdb.conf":
     ensure => "file",
	 owner => "puppet",
     group => "puppet",
     mode => 755,
	 content => template('foreman_puppetdb/puppetdb.conf.erb'),
     require =>  Package['puppetdb-terminus']
   }
   
   file { "/etc/puppet/routes.yaml":
     ensure => "file",
	 owner => "puppet",
     group => "puppet",
     mode => 755,
	 source => 'puppet:///modules/foreman_puppetdb/routes.yaml',
     require =>  File["/etc/puppet/puppetdb.conf"]
   } 
   
   exec { 'permanently disable puppetmaster service':
     command     => "chkconfig --level 12345 puppetmaster off",
     cwd         => "/tmp",
     require    =>   File["/etc/puppet/routes.yaml"]
   }   
     
   exec { 'service puppetmaster stop':
     command     => "service puppetmaster stop",
     cwd         => "/tmp",
     require    =>   Exec["permanently disable puppetmaster service"]
   }   

   # restart puppetmaster under httpd and passenger  
	exec { 'service httpd restart again':
     command     => "service httpd restart",
     cwd         => "/tmp",
     require    =>   Exec["service puppetmaster stop"]
   }    
    
   # check puppetdb log to see it is working
   #      /var/log/puppetdb/puppetdb.log 
   # check a client can connecti 
   
	 
}	 