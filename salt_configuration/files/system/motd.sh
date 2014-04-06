#!/bin/bash                                                                                                                                                                                          
#define the filename to use as output
motd="/etc/motd"
# Collect useful information about your system
# $USER is automatically defined
HOSTNAME=`uname -n`
KERNEL=`uname -r`
#CPU=`uname -p`
MODEL=`dmidecode -s system-product-name`
ARCH=`uname -m`
MEM=`free -m|sed -n "2p" |awk '{print $2}'`
CPU=`cat /proc/cpuinfo |awk -F: '$0~/model name/{print $2}'|head -n 1|sed '1,$s/     //g'`
CPUNUM=`cat /proc/cpuinfo |awk -F: '$1~/processor/'|wc -l`
VIDEO=`lspci | grep -i 'VGA' |awk -F":" '{print $3}'`
SYSTEM=`lsb_release -id|sed -n '2p' |awk -F":" '{print $2}' |sed  "s/^[\t]*//"`

# The different colours as variables
W="\033[01;37m"
B="\033[01;34m"
R="\033[01;31m"
G="\033[01;32m"
X="\033[00;37m"
clear > $motd # to clear the screen when showing up
echo -e "$G#=============================================================================#" >> $motd
echo -e "   $W Welcome $B $USER $W to $B $HOSTNAME                " >> $motd
echo -e "   $G OWNER1 $W= $R$OWNER                              " >> $motd
echo -e "   $G OWNER2 $W= $R$OWNER2                              " >> $motd
echo -e "   $R Model  $W= $MODEL                                   " >> $motd
echo -e "   $R System $W= $SYSTEM                                   " >> $motd
echo -e "   $R Arch   $W= $ARCH                                   " >> $motd
echo -e "   $R Kernel $W= $KERNEL                                 " >> $motd
echo -e "   $R Cpu    $W=$CPU x $CPUNUM                          " >> $motd
echo -e "   $R Memory $W= ${MEM}MB                                " >> $motd
echo -e "   $R Video  $W=$VIDEO                                  " >> $motd
echo -e "" >> $motd
echo -e "   the keychain may ask passphrase of private key of gitcorp. " >> $motd
echo -e "   please just ignore it ;) " >> $motd
echo -e "$G#=============================================================================#" >> $motd
echo -e "$X" >> $motd
