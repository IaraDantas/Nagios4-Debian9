#!/bin/bash

###################################################################
# Name            : nag4-deb9.sh                                  #
# Description     : Basic Nagios core v4 instalation for Debia v9 #
# Author          : Iara de Melo Dantas Bezerra                   #
# Email           : iaradantasredes@gmail.com                     #
# Version         : 0.7                                           #
# Period          : 06/2019                                       #
###################################################################

######################VERIFICATIONS################################

##########################
echo
echo 'Welcome, please wait the basics verifications'

# First verification - Root user
# To verify if the Root user is logged in -- OK
if [ $USER == "root" ]
then
echo $USER >> /tmp/log.txt
date >> /tmp/log.txt
echo 'User root verification -> OK' >> /tmp/log.txt
echo ''>> /tmp/log.txt
else
echo
echo ' ERROR - Please run with ROOT USER!'
echo
echo '         Important: Command SUDO not accepted'
echo
echo
sleep 2
exit
fi

# Second verification - /tmp directory
# To verify if /tmp directory exists, if not found, this script
# will create him, file log criation. -- OK

if [ -e "/tmp" ]
then
echo $USER >> /tmp/log.txt
date >> /tmp/log.txt
echo '/tmp verification -> successfull' >> /tmp/log.txt
else
mkdir /tmp
echo $USER >> /tmp/log.txt
date >> /tmp/log.txt
echo '/tmp criation -> successfull' >> /tmp/log.txt
echo 'Command mkdir /tmp' >> /tmp/log.txt
echo '' >> /tmp/log.txt
fi
##########################

# Third verification - Network Access
# To verify if there is network access -- OK

echo $USER >> /tmp/log.txt
date >> /tmp/log.txt
echo 'Access verification' >> /tmp/log.txt
echo '' >> /tmp/log.txt
if ! ping -c 5 www.google.com.br >> /tmp/log.txt ;
then
echo 'ERROR - No network access, please try again later'
echo 'Network Error -> No network access' >> /tmp/log.txt
echo '' >> /tmp/log.txt
sleep 2
exit
else
echo
sleep 3
echo 'Network access Verification -> OK' >> /tmp/log.txt
echo '' >> /tmp/log.txt
fi

##########################
###############################################################
#####################END OF BASICS VERIFICATIONS###############
###############################################################

echo
echo 'End of basics verifications' >> /tmp/log.txt
echo '' >> /tmp/log.txt

######### Main Menu ##########
# To introduce the main options -- OK


echo '    BASIC NAGIOS CORE INSTALLER'
echo '----------------------------------'
echo
echo
echo '      : ISO can be requested'
echo '      : Data entry will be requested'
echo
echo '       Please wait    '
echo
sleep 3
echo '             MAIN MENU'
echo
echo
echo '1 - Nagios core v4 Instalation'
echo
echo '2 - Network asset Menu'
echo
echo '3 - Exit'
echo
echo
echo 'Enter the option: '
read MAINOP
echo


####################################################

############ Verification of the option ###########

echo '' >> /tmp/log.txt
echo $USER >> /tmp/log.txt
date >> /tmp/log.txt
echo 'Nagios core Main menu' >> /tmp/log.txt
echo '' >> /tmp/log.txt

case $MAINOP in
1) # Option that install the nagios core v4 and them plugins

     echo '     Nagios core v4'
     echo 'Nagios Intalation option' >> /tmp/log.txt
     echo
     echo
     echo 'Verify that the network mirrors are configured correctly'
     echo 'Place to Check: /etc/apt/sources.list'
     echo
     echo
     sleep 5
     echo '...Updating repositories, please wait.'
     echo
     sleep 2
     echo 'Update repositóries' >> /tmp/log.txt
     sed -i -r "/cdrom/s/^/#/g" /etc/apt/sources.list
     #update repositories - ISO requested -- OK
     apt-get update >> /tmp/log.txt
     echo
     echo
     echo '...Installing prerequisites, that step may take a while'
     echo
     sleep 2

     #install the prerequisites -- OK
     echo 'Install the prerequisites' >> /tmp/log.txt
     echo '' >>/tmp/log.txt
     apt-get install -y autoconf gcc libc6 make wget unzip apache2-utils php libgd-dev >> /tmp/log.txt
     cd /tmp
     echo 'Prerequisites Installation -> Successfull'
     echo 'Command cd /tmp' >> /tmp/log.txt
     echo '' >> /tmp/log.txt
     echo
     echo

     #Get the nagios core -- OK
     echo '' >> /tmp/log.txt
     echo 'Geting Nagios core, please wait'
     echo
     sleep 3
     echo 'Get Nagios core' >> /tmp/log.txt
     echo 'Command wget -O nagisocore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.3.tar.gz ' >> /tmp/log.txt
     wget -O nagisocore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.3.tar.gz >> /tmp/log.txt
     tar xzf nagisocore.tar.gz >> /tmp/log.txt
     echo 'Command tar xzf nagioscore.tar.gz' >> /tmp/log.txt
     echo 'Command cd nagioscore-nagios-4.4.3/' >> /tmp/log.tx
     cd nagioscore-nagios-4.4.3/
     echo

     #Compiling -- OK
     echo 'Compiling' >> /tmp/log.txt
     echo '...Compiling, please wait'
     echo
     sleep 2
     echo 'Command ./configure --with-httpd-conf=/etc/apache2/sites-enabled' >> /tmp/log.txt
     ./configure --with-httpd-conf=/etc/apache2/sites-enabled >> /tmp/log.txt
     echo 'Command make all' >> /tmp/log.txt
     make all >> /tmp/log.txt
     echo
     echo '...Creating nagios user and group'
     echo 'Creating nagios user/group' >> /tmp/log.txt
     echo
     sleep 2
     echo 'Command make install-groups-users' >> /tmp/log.txt
     make install-groups-users >> /tmp/log.txt
     echo 'Command usermod -a -G nagios www-data' >> /tmp/log.txt
     usermod -a -G nagios www-data >> /tmp/log.txt
     echo
     echo '...Install binaries and configuration files, please wait'
     echo 'Install binares and configuration files' >> /tmp/log.txt
     echo
     sleep 3
     echo 'Command make install' >> /tmp/log.txt
     make install >> /tmp/log.txt
     echo
     echo 'Command make install-daemoninit' >> /tmp/log.txt
     make install-daemoninit >> /tmp/log.txt
     echo
     echo 'Command make install-commandmode' >> /tmp/log.txt
     make install-commandmode >> /tmp/log.txt
     echo
     echo 'Command make install-config' >> /tmp/log.txt
     make install-config >> /tmp/log.txt
     echo
     echo 'Command make install-webconf' >> /tmp/log.txt
     make install-webconf >> /tmp/log.txt
     echo

     # Start Apache and Nagios services -- OK
     echo '...Starting Apache and Nagios service, please wait'
     echo 'Starting Apache and Nagios service' >> /tmp/log.txt
     echo
     sleep 2
     a2enmod rewrite
     a2enmod cgi
     echo
     echo '...Allowing tcp connections on port 80 using iptables, please wait'
     echo 'Allowing tcp connections on port 80 using iptables' >> /tmp/log.txt
     echo
     sleep 3
     echo '' >> /tmp/log.txt
     iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT
     apt-get install -y iptables-persistent
     #iptables-save > /etc/iptables/rules.v4
     echo

     # Creating Nagios User Account -- OK
     echo '...Creating Nagios User Account'
     echo
     echo
     echo 'Enter an username for web access'; read NAGNAME
     htpasswd -c /usr/local/nagios/etc/htpasswd.users $NAGNAME
     echo 'Creation Nagios user account -> successfull' >> /tmp/log.txt
     echo

     #Start initialization for apache and nagios services -- OK
     echo '...Configuring start initialization for apache and nagios services'
     systemctl restart apache2.service
     systemctl start nagios.service
     #systemctl enable nagios.service apache2.service

     # Install and configurate the plugins -- OK
     echo
     echo '...Installing plugins, please wait'
     echo
     echo 'Install plugins' >> /tmp/log.txt
     echo '' >> /tmp/log.txt
     sleep 3
     echo 'Command apt-get install -y autoconf libmcrypt-dev libssl-dev bc gawk dc build-essential snmp libnet-snmp-perl getext' >> /tmp/log.txt
     apt-get install -y autoconf libmcrypt-dev libssl-dev bc gawk dc build-essential snmp libnet-snmp-perl gettext >> /tmp/log.txt
     echo
     echo 'Command wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz' >> /tmp/log.txt
     wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz >> /tmp/log.txt
     echo 'Command tar zxf nagios-plugins.tar.gz' >> /tmp/log.txt
     tar zxf nagios-plugins.tar.gz
     echo 'Command cd nagios-plugins-release-2.2.1/' >> /tmp/log.txt
     cd nagios-plugins-release-2.2.1/
     echo
     echo '...Configuring plugins, please wait'
     echo
     echo 'Configuring plugins' >> /tmp/log.txt
     echo 'Command ./tools/setup' >> /tmp/log.txt
     ./tools/setup >> /tmp/log.txt
     echo 'Command ./configure' >> /tmp/log.txt
     ./configure >> /tmp/log.txt
     echo 'Command make' >> /tmp/log.txt
     make >> /tmp/log.txt
     echo 'Command make install' >> /tmp/log.txt
     make install >> /tmp/log.txt
     echo
     echo '' >> /tmp/log.txt
     echo $USER >> /tmp/log.txt
     date >> /tmp/log.txt
     # enable the new user in cgi file
     sed -i -r "/nagiosadmin/s/nagiosadmin/nagiosadmin,$NAGNAME/g" /usr/local/nagios/etc/cgi.cfg

     echo 'End of Nagios core installation' >> /tmp/log.txt
     echo '' >> /tmp/log.txt
     echo
     echo '    End of Nagios installation'
     echo
     echo
     echo
     echo 'Access Nagios interface using a web browser'
     echo 'Go to http://127.0.0.1/nagios'
     echo
     echo
     echo 'For insert new assets, please run it again'
     echo 'and follow the instructions'
     echo '------------------------------------------'
     echo
     echo 'Check the log file: /tmp/log.txt'
     echo 'For more detais, visit https://www.nagios.org/documentation/'
     echo
     echo ;;

2)
     echo $USER >> /tmp/log.txt
     date >> /tmp/log.txt
     echo 'Network assets Menu' >> /tmp/log.txt
     echo
     echo '      Network assets Menu'
     echo
     echo
     echo
     echo '1 - Insert a new GNU/Linux host'
     echo
     echo '2 - Insert a new Windows host'
     echo
     echo '3 - Insert a new Router/Switch'
     echo
     echo '4 - Exit'
     echo
     echo
     echo 'Enter the option: '
     read NETASSOP
     echo
     echo

     case $NETASSOP in

          1)
               # GNU/Linux host
               echo 'GNU/Linux option' >> /tmp/log.txt
               echo
               echo '     GNU/Linux new host'
               echo
               echo
               echo '       :The NRPE plugin must be installed correctly'
               echo
               echo
               sleep 3
               echo
               echo 'Insert the hostname : ' ; read LHNAME
               echo 'Insert the alias :' ; read LHALIAS
               echo 'Insert the host IP address :' ; read LHIP
               echo
               echo
               echo 'Please wait'

               # Create backup file
               cat /usr/local/nagios/etc/objects/localhost.cfg >> /usr/local/nagios/etc/objects/localhost.bkp


               # Insert the host
               echo '' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '# Definitions for monitoring a Linux host' >> /usr/local/nagios/etc/objects/localhost.cfg

               echo '###############################################################################' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '# Define a host for the linux machine' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo 'define host {'>> /usr/local/nagios/etc/objects/localhost.cfg
               echo '    use                     linux-server            ; Name of host template to use' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '                                                    ; This host definition will inherit all variables that are defined' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '                                                    ; in (or inherited by) the linux-server host template definition.' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    host_name               $LHNAME" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    alias                   $LHALIAS" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    address                 $LHIP" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '}' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo

               echo '##############################################################################' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '# Define a service to "ping" the linux machine' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo 'define service {' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    use                     local-service           ; Name of service template to use" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    host_name               $LHNAME" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '    service_description     PING' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '    check_command           check_ping!100.0,20%!500.0,60%' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '}' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo

               echo "# Define a service to check the disk space of the root partition" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "# on the local machine.  Warning if < 20% free, critical if " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "# < 10% free space on partition. " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "define service { " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    use                     local-service           ; Name of service template to use " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    host_name               $LHNAME " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    service_description     Root Partition " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    check_command           check_local_disk!20%!10%!/ " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "} " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "" >> /usr/local/nagios/etc/objects/localhost.cfg

               echo "# Define a service to check the number of currently logged in " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "# users on the local machine.  Warning if > 20 users, critical " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "# if > 50 users. " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "define service { " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    use                     local-service           ; Name of service template to use " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    host_name               $LHNAME " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    service_description     Current Users " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    check_command           check_local_users!20!50 " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "} " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "" >> /usr/local/nagios/etc/objects/localhost.cfg

               echo "# Define a service to check the load on the local machine. " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "define service { " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    use                     local-service           ; Name of service template to use " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    host_name               $LHNAME " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    service_description     Current Load " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    check_command           check_local_load!5.0,4.0,3.0!10.0,6.0,4.0 " >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "}" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "" >> /usr/local/nagios/etc/objects/localhost.cfg

               echo '##############################################################################' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '# Define a service to check the number of currently running procs' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '# on the local machine.  Warning if > 250 processes, critical if' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '# > 400 processes.' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo 'define service {' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '    use                     local-service           ; Name of service template to use' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo "    host_name               $LHNAME" >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '    service_description     Total Processes' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '    check_command           check_local_procs!250!400!RSZDT' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '}' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo '' >> /usr/local/nagios/etc/objects/localhost.cfg
               echo
               systemctl restart nagios.service
               echo "New GNU/Linux host added"
               echo
               echo "New GNU/Linux host added" >> /tmp/log.txt
               echo "HOST: $LHNAME; IP: $LHIP " >> /tmp/log.txt
               echo
               echo 'Basic configuration: '
               echo
               echo 'Only basics parameters will be monitored'
               echo 'Such as Disc space, numbers of currently logged'
               echo 'users on the machine'
               echo
               echo
               echo '        For more informations verify:'
               echo '        /usr/local/nagios/etc/objects/localhost.cfg'
               echo '        /tmp/log.txt'
               echo
               sleep 5
               echo
               echo ;;
          2)
               #Insert a new windows host
               echo 'Windows option' >> /tmp/log.txt
               echo
               echo '     Windows new host'
               echo
               echo
               echo '       :The NSCliente++ must be installed correctly on client'
               echo
               echo
               sleep 3
               echo 'Insert the hostname: ' ; read WHNAME
               echo 'Insert the alias :' ; read WHALIAS
               echo 'Insert the host IP address' ; read WHIP
               echo
               echo 'This is your first Windows host? (y/n)' ; read FHTEST
               echo
               echo
               echo 'Please wait'
               echo
               echo
               # Create a backup file and registrate the changes
               echo 'Last state of the windows.cfg file' >> /tmp/log.txt
               cat /usr/local/nagios/etc/objects/windows.cfg >> /tmp/log.txt
               cp /usr/local/nagios/etc/objects/windows.cfg /usr/local/nagios/etc/objects/windows.bkp

               # Test if is the first host
               case $FHTEST in
               y)
                    echo 'Removed the windows.cfg, see windows.cfg~ for see the defaut' >> /tmp/log.txt
                    # Enable path and remove the first file (after register them, and create the backup file)
                    sed -i -r 's/^#(.*windows.cfg.*)$/\1/' /usr/local/nagios/etc/nagios.cfg
                    rm /usr/local/nagios/etc/objects/windows.cfg
                    echo ;;

               n)
                    #Don't need remove the file
                    echo ;;

               esac
               # insert the new host
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '#########################################################################' >> /usr/local/nagios/etc/objects/windows.cfg
               echo "# Define a host for the Windows machine we'll be monitoring" >> /usr/local/nagios/etc/objects/windows.cfg
               echo '# Change the host_name, alias, and address to fit your situation' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg
               echo ' define host {' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '    use                     windows-server          ; Inherit default values from a template' >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    host_name               $WHNAME               ; The name we're giving to this host" >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    alias                   $WHALIAS       ; A longer name associated with the host" >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    address                 $WHIP             ; IP address of the host" >> /usr/local/nagios/etc/objects/windows.cfg
               echo '}' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg

               echo '#########################################################################' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '# Define a hostgroup for Windows machines' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '# All hosts that use the windows-server template will automatically be a member of this group' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg
               echo 'define hostgroup {' >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    hostgroup_name          windows-servers         ; The name of the hostgroup" >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    alias                   Windows Servers         ; Long name of the group" >> /usr/local/nagios/etc/objects/windows.cfg
               echo '}' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg

               echo '########################################################################' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '# Create a service for monitoring CPU load' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '# Change the host_name to match the name of the host you defined above' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg
               echo 'define service {' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '    use                     generic-service' >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    host_name               $WHNAME" >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    service_description     CPU Load" >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    check_command           check_nt!CPULOAD!-l 5,80,90" >> /usr/local/nagios/etc/objects/windows.cfg
               echo '}' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg

               echo "#########################################################################" >> /usr/local/nagios/etc/objects/windows.cfg
               echo '# Create a service for monitoring memory usage' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '# Change the host_name to match the name of the host you defined above' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg
               echo 'define service {' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '    use                     generic-service' >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    host_name               $WHNAME" >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    service_description     Memory Usage" >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    check_command           check_nt!MEMUSE!-w 80 -c 90" >> /usr/local/nagios/etc/objects/windows.cfg
               echo '}' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg

               echo '########################################################################' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '# Create a service for monitoring C:\ disk usage' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '# Change the host_name to match the name of the host you defined above' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg
               echo 'define service {' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '    use                     generic-service' >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    host_name               $WHNAME" >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    service_description     C:\ Drive Space" >> /usr/local/nagios/etc/objects/windows.cfg
               echo "    check_command           check_nt!USEDDISKSPACE!-l c -w 80 -c 90" >> /usr/local/nagios/etc/objects/windows.cfg
               echo '}' >> /usr/local/nagios/etc/objects/windows.cfg
               echo '' >> /usr/local/nagios/etc/objects/windows.cfg

               # Restart the service
               systemctl restart nagios.service
               echo 'New Windows host added'
               echo 'New windows host added' >> /tmp/log.txt
               echo 'HOST: $WHNAME, $WHIP' >> /tmp/log.txt
               echo
               echo
               echo 'Basic configuration: '
               echo
               echo 'Only basics parameters will be monitored'
               echo 'Such as CPU, Memory usage and Disc usage'
               echo
               echo
               echo '     For more information and options verify:'
               echo '     /usr/local/nagios/etc/objects/windows.cfg'
               echo '     /usr/local/nagios/etc/objects/windows.cfg~'
               echo
               echo
               sleep 5
               echo ;;


          3)
               # New Router/Switch option 
               echo 'Router/Switch option' >> /tmp/log.txt
               echo
               echo '     New Router/Switch'
               echo
               echo
               echo 'Important: This option ONLY INSERT'
               echo '           new Routers and Switches.'
               echo '           For modify them, please see:'
               echo '           /usr/local/nagios/etc/objects/switch.cfg'
               echo
               echo
               echo 'This is your first Asset ? (y/n)' ; read FATEST
               echo
               sleep 3
               echo 'Insert the Router/Switch name: ' ; read RSNAME
               echo 'Insert the alias :' ; read RSALIAS
               echo 'Insert the IP address :' ; read RSIP
               echo 'Insert the Group :' ; read RSGROUP
               echo 'Insert the community :' ; read RSCOMM
               echo
               echo
               echo "Please wait $FATEST"
               echo

               # Create the backup file
               cat /usr/local/nagios/etc/objects/switch.cfg >> /usr/local/nagios/etc/objects/switch.bkp

               #Test if is the first asset
               case $FATEST in

               y)
                    echo 'The first state of the switch.cfg file, see switch.cfg~ for defaut' >> /tmp/log.txt
                    cat /usr/local/nagios/etc/objects/switch.cfg >> /tmp/log.txt
                    rm /usr/local/nagios/etc/objects/switch.cfg

                    # Enable path
                    sed -i -r 's/^#(.*switch.cfg.*)$/\1/' /usr/local/nagios/etc/nagios.cfg
                    echo ;;
               n)
                    echo ;;
               esac

               # Insert the asset
               echo '' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '######################################################' >> /usr/local/nagios/etc/objects/switch.cfg
               echo "# Define the switch that we'll be monitoring" >> /usr/local/nagios/etc/objects/switch.cfg
               echo 'define host {' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '    use                     generic-switch                      ; Inherit default values from a template' >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    host_name               $RSNAME                             ; The name we're giving to this switch" >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    alias                   $RSALIAS                            ; A longer name associated with the switch" >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    address                 $RSIP                               ; IP address of the switch" >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    hostgroups              $RSGROUP                    ; Host groups this switch is associated with" >> /usr/local/nagios/etc/objects/switch.cfg
               echo '}' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '' >> /usr/local/nagios/etc/objects/switch.cfg

               echo '###############################################################################' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '# Create a new hostgroup for switches' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '' >> /usr/local/nagios/etc/objects/switch.cfg
               echo 'define hostgroup {' >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    hostgroup_name          $RSGROUP                            ; The name of the hostgroup" >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    alias                   $RSGROUP                    ; Long name of the group" >> /usr/local/nagios/etc/objects/switch.cfg
               echo '}' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '' >> /usr/local/nagios/etc/objects/switch.cfg

               echo '###############################################################################' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '# Create a service to PING to switch' >> /usr/local/nagios/etc/objects/switch.cfg
               echo 'define service {' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '    use                     generic-service                     ; Inherit values from a template' >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    host_name               $RSNAME                     ; The name of the host the service is associated with" >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    service_description     PING                                ; The service description" >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    check_command           check_ping!200.0,20%!600.0,60%      ; The command used to monitor the service" >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    check_interval          5                                   ; Check the service every 5 minutes under normal conditions" >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    retry_interval          1                                   ; Re-check the service every minute until its final/hard state is determined" >> /usr/local/nagios/etc/objects/switch.cfg
               echo '}' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '' >> /usr/local/nagios/etc/objects/switch.cfg

               echo '# Monitor uptime via SNMP' >> /usr/local/nagios/etc/objects/switch.cfg
               echo 'define service {' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '    use                     generic-service                     ; Inherit values from a template' >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    host_name               $RSNAME" >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    service_description     Uptime" >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    check_command           check_snmp!-C $RSCOMM -o sysUpTime.0" >> /usr/local/nagios/etc/objects/switch.cfg
               echo '}' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '' >> /usr/local/nagios/etc/objects/switch.cfg

               echo '# Monitor Port 1 status via SNMP' >> /usr/local/nagios/etc/objects/switch.cfg
               echo 'define service {' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '    use                     generic-service                     ; Inherit values from a template' >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    host_name               $RSNAME" >> /usr/local/nagios/etc/objects/switch.cfg
               echo '    service_description     Port 1 Link Status' >> /usr/local/nagios/etc/objects/switch.cfg
               echo "    check_command           check_snmp!-C $RSCOMM -o ifOperStatus.1 -r 1 -m RFC1213-MIB" >> /usr/local/nagios/etc/objects/switch.cfg
               echo '}' >> /usr/local/nagios/etc/objects/switch.cfg
               echo '' >> /usr/local/nagios/etc/objects/switch.cfg
               echo
               # Restart the service
               systemctl restart nagios.service

               echo 'Router/Switch added'
               echo 'ROUTER/SWITCH added' >> /tmp/log.txt
               echo "ASSET: $RSNAME, $RSIP " >> /tmp/log.txt
               echo
               echo
               echo 'Basic Configuration: '
               echo '    Only basics parameters will be monitored'
               echo '    such as status port, PING and Uptime'
               echo
               echo 'Important: This configurations'
               echo '           are applicated on port 1'
               echo
               echo
               echo
               echo 'For more information and options see:'
               echo '/usr/local/nagios/etc/objects/switch.cfg'
               echo '/usr/local/nagios/etc/objects/switch.cfg~'
               echo
               echo ;;

          4)
               echo 'Exit Option' >> /tmp/log.txt
               echo
               echo 'See you later'
               echo
               sleep 2
               echo ;;

          *)
               echo 'ERROR Option' >> /tmp/log.txt
               echo
               echo 'OPS, INVALID OPTION'
               echo
               echo 'Try again, see you'
               echo
               sleep 1
               echo ;;

     esac;;

     3)
          echo 'Exit Option' >> /tmp/log.txt
          echo
          echo 'See you later'
          echo
          sleep 1
          echo ;;


     *)
          echo 'ERROR Option' >> /tmp/log.txt
          echo
          echo 'OPS, INVALID OPTION'
          echo
          echo 'Try again, see you'
          echo
          sleep 1
          echo ;;

esac
