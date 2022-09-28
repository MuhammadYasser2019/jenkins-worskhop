#!/bin/bash

set -e
MOUNTPOINTS="/github /jenkins"
MACHINES="workstation servera serverb serverc"

for i in $MACHINES ; do
    if [ $i == "servera" ] ; then
       echo -e "#### Below you will find the hostname #### \n \n"
      ssh $i hostname
    fi
done

for i in $MACHINES ; do
    echo -e "#### Below you will find the fstab file result #### for server ##### $i ####  \n \n"	
    ssh $i cat /etc/fstab    
    echo -e "\n \n"
    ssh $i mkdir -p /home/student/.gituser-dir  
    echo -e "IF the directory is created before and already has data, it will show down" 	
    ssh $i ls -l /home/student/.gituser-dir
    echo -e " ##### passing to the next machine #### \n \n"
done

function create_user() {
     echo -e "User gituser will be created if it doesn't exist on #### $(hostname) ####" 	
     id -u gituser  &>/dev/null || useradd gituser 
     echo "gituser:teste123" | chpasswd
     id gituser
     mkdir -p /root/.gituser-dir
     echo -e "IF the directory in the #### $(hostname) #### is created before and already has data, it will show down" 	
     ls -l /root/.gituser-dir
}

function mkdir_mountpoints() {
    for dir in $MOUNTPOINTS; do mkdir -p $dir; done
}

function add_sudoer() {
    cat >/etc/sudoers.d/github-sudo <<'EOF'
gituser    ALL=(ALL)       ALL
EOF
}

function chech_repolist() {
    yum repolist 
}
create_user
#mkdir_mountpoints
add_sudoer
#chech_repolist

