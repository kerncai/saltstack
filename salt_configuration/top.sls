#####################################################################################

### system          系统基本设置(resolv,yum,vim,ssh,key,motd,sudo,iptables,syslog)
### salt-minion     salt-minion安装及配置
### clear           清理puppet, mcollective

### user            用户管理
### cron            crontab管理
### zabbix          zabbix监控系统部署

### python          安装ajk-python2.7并添加模块setuptools, pip, virtualenv
### virtualenv      新建python虚拟环境

### nginx           nginx安装与配置
### php             phpfpm安装与配置
### squid           squid图片缓存安装与配置
### city_webserver  city部署web服务
### my_webserver    my部署web服务

### city_code       city代码配置
### user_code       user代码配置

#写模块测试的时候不要用'*'去匹配机器，请直接使用主机名
#####################################################################################

base:
  '*':
    - system
    - salt-minion
    - zabbix

  dns:
    - match: nodegroup

  my_app:
    - match: nodegroup
    - my_webserver

  squid_20:
    - match: nodegroup
    - squid

  mendian:
    - match: nodegroup
    - mendian

  person:
    - match: nodegroup
    - person
