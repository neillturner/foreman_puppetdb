# == Class: foreman_puppetdb
#
# classes to install foreman, puppet and puppetdb 
# 
#
class foreman_puppetdb (
  $foreman_url = 'http://yum.theforeman.org/releases/1.3/el6/x86_64/foreman-release.rpm',
  $server_name = $fqdn,
  $epel_url = 'http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm',
  $epel = 'epel-release-6-8.noarch.rpm'
){

   class { 'foreman_puppetdb::prereqs':
        epel_url =>  $epel_url,
		epel =>  $epel
   }

   class { 'foreman_puppetdb::install':
       foreman_url =>  $foreman_url,
	   server_name   => $server_name,
       require     =>  Class['foreman_puppetdb::prereqs']
   } 

    class { 'foreman_puppetdb::puppet_database':
	  server_name  => $server_name, 
      require    =>  Class['foreman_puppetdb::install']
   }   
 
}
