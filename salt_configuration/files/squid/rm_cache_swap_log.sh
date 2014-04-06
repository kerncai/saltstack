#!/bin/bash
LOG_PATH=/var/log/squid
CODE=`du -sh ${LOG_PATH} | sed 's/\(.*\)G.*/\1/'`

if [ ${CODE} -gt 14 ];then

   > ${LOG_PATH}/cache_swap_log.05
   > ${LOG_PATH}/cache_swap_log.04

fi
