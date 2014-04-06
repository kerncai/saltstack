########################################################################
# File Name: check_squid_status.sh
# Author: kerncai
# mail: kernkerncai@gmail.com
# Created Time: 2013年11月12日 星期二 10时30分05秒
#########################################################################
#!/bin/bash

five_ratios(){
/usr/local/squid-2.7/bin/squidclient -h localhost -p 3128 mgr:info |grep 'Request Hit Ratios:' |awk '{print$5/100}'
}

six_ratios(){
/usr/local/squid-2.7/bin/squidclient -h localhost -p 3128 mgr:info |grep 'Request Hit Ratios:' |awk '{print$7/100}'
}

objects(){
/usr/local/squid-2.7/bin/squidclient -h localhost -p 3128 mgr:info |grep 'on-disk objects' |awk '{print$1/100000000}'
}

space(){

/usr/local/squid-2.7/bin/squidclient -hlocalhost -p 3128 mgr:storedir |grep 'Filesystem Space in use:' |awk -F '/' '{print$1}'|awk '{s+=$5};END{printf "%4.2f\n",s/1024/1024}'

}

$1
