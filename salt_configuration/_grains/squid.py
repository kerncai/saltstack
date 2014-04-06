# -*- coding: utf-8 -*-

'''
Module for squid disk information by python2.7.3
'''


import commands
import os

def cache():
    '''
    Return the cache usage information for volumes mounted on this minion
    '''
    grains={}
    m = commands.getoutput("free -g|awk '$0~/Mem/ {print$2+1}'")
    grains['cache_mem_size']=int(int(m)*(0.45))

    file = commands.getoutput("df -Th |awk '{print$7}'")
    cache = 'cache'
    
    if cache in file:

        a = commands.getoutput("df -Th |grep cache |awk 'NR==1 {print$3}' |sed 's/G//g'")
        b = int(int(a)*(0.9))
        if b >= 65:
            grains['cache_disk_size'] = 65*1024
        else:
            grains['cache_disk_size'] = int(b*1024)
    else:
        grains['cache_disk_size'] = 'The cache of partition does not exist'
    
    return grains
