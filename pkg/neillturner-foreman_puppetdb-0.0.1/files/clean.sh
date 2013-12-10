echo ""
echo "          **** FOREMAN/PUPPETMASTER CLEANUP SCRIPT *****"
echo ""
echo "                     ****DANGER****"
echo ""
echo " This script will clean up the puppetmaster server so it can be re-installed"
echo "             The puppet software will be removed!!"
echo ""
echo " It will not be able to be recovered without re-installing!!!"
echo ""
read -p "Continue (yes/no)?" CONT
if [ "$CONT" == "yes" ]; then
  yum -y remove puppet
  yum -y remove foreman-proxy
  yum -y remove foreman
  yum -y remove postgresql
  yum -y remove postgresql-libs
  yum -y remove httpd
  rm -rf /etc/puppet
  rm -rf /etc/puppetdb
  rm -rf /etc/foreman
  rm -rf /etc/foreman-proxy
  rm -rf /etc/httpd
  rm -rf /var/lib/puppet
  rm -rf /var/lib/puppetdb
  rm -rf /var/lib/foreman
  rm -rf /var/lib/foreman-proxy
  rm -rf /var/run/foreman
  yum -y install httpd
fi
