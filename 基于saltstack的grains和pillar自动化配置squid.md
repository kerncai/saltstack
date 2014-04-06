之前的几篇记录了salt的安装、配置、以及各个模块的使用，今天主要基于salt的grains和pillar自动化部署squid缓存服务。

动手之前先确定下当前需求：

 1. 我们有两个机房，两个机房的ip地址是不同的，一个是10.10.开头，另外一个是10.20.开头；
 2. 10.10.开头的机房主要用来缓存js、css等，另外一个机房的squid机器主要用来缓存图片，这两个的配置文件肯定是不同的 
 3. 缓存图片服务的squid机器硬盘大小不同，也就是说要做的cache大小肯定也是不同的
 4. 机器的内存并不是统一大小
 
整理如下：
 
     1.首先要通过salt自动安装squid服务
     2.要自己编写grains模块收集机器的内存和硬盘大小
     3.要使用pillar确认机器的ip地址是以什么开头的，以此来确认是用来缓存的具体对象
     4.整理具体配置分发到不同服务的squid配置文件内

一、先整理squid的安装包
--------------

自己整理好的squid-2.7的rpm包，通过yum的方式来安装
编写state.sls文件
在根目录下/srv/salt下进行，vim squid.sls

    squid:
      pkg:
        - name: ajk-squid #我自己打的rpm包
        - installed
      user.present:    #检测用户，如果没有就创建 squid用户，设置为nologin状态
      - home: {{ pillar['squid_home_dir'] }} 
      - shell: /sbin/nologin
      - require:
        - group: squid
      group.present:   #用户组squid 和用户对应
        - name: squid
        - require:
          - pkg: ajk-squid
      service.running:  #这里保持squid服务是正常运行的状态
        - enable: True
        - reload: True
        - require:
          - file: /etc/init.d/squid      #squid的启动脚本，也是打包在安装包内的，检测下面的watch内的服务，有变化就执行
        - watch:
          - file: {{ pillar['squid_conf_dir'] }}/squid.conf
          {{ pillar['squid_conf_dir'] }}/squid.conf:

     file.managed:
        - source: salt://files/squid/squid.conf # 定义salt内的squid.conf配置文件
        - user: root
        - mode: 644
        - template: jinja   #使用jinja模板，这里是为了配置文件内使用pillar
        - require:
          - pkg: ajk-squid  #依赖关系

{{ pillar['squid_home_dir'] }} 这里在pillar内定义好的，我是为了美观方便；之前填写下面的目录也是可以的

    squid_home_dir: /usr/local/squid-2.7
    squid_conf_dir: /usr/local/squid-2.7/etc

目前，squid服务的state.sls模块就已经写好了

二、收集服务器端的硬件信息
-------------

还是要使用python脚本，在_grains下面编写脚本,编写脚本前确认下配置；我的需求是squid的内存设置为总内存的45%，我squid的硬盘会有三块，挂载为目录cache1、cache2、cache3 。每块盘取90%，如果90%之后大于65G，直接取值65，少于65的话，直接使用90%的值。
脚本如下：

    vim squid.py
    
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

我的squid机器在salt上面定义了一个组：
root@salt _grains # cat /etc/salt/master.d/nodegroups.conf 

    nodegroups:
      squid_20: 'cdn20-*

'然后，加载编写的模块，命令如下 ：

    salt -N squid_20 saltutil.sync_all

查询编写的模块取值，根据disk信息取值：

    root@salt _grains # salt -N 'squid_20' grains.item cache_disk_size
    cdn20-005:
      cache_disk_size: 43008
    cdn20-001:
      cache_disk_size: 66560

 查询内存信息取值：

    root@salt _grains # salt -N 'squid_20' grains.item cache_mem_size
    cdn20-005:
      cache_mem_size: 7
    cdn20-001:
      cache_mem_size: 14

三、编写squid.conf的配置文件
-------------------
根据上文的目录定义，路径在/srv/salt/files/squid下
vim squid.conf

    {#% if grains['ip_interfaces'].get('eth0')[0].startswith('10.20') %#} (#去掉)
    ...........省略具体配置
    ## MEMORY CACHE OPTIONS
    cache_mem {{ grains['cache_mem_size'] }} GB #内存的大小
    ## DISK CACHE OPTIONS
    cache_dir aufs /cache1 {{ grains['cache_disk_size'] }} 16 256 #cache的大小
    cache_dir aufs /cache2 {{ grains['cache_disk_size'] }} 16 256
    cache_dir aufs /cache3 {{ grains['cache_disk_size'] }} 16 256
    visible_hostname {{ grains['host'] }} #机器名
    {#% else %#} (#去掉)
      缓存js等的配置文件，此处省略
    {#% endif %#}(#去掉)

这里只是说明下salt需要配置的东西，至于squid具体的配置文件，这里就不多说了
当然，上述的判断可以在pillar里面做完而不用在配置文件的时候做判断，只不过我感觉那样要多一层逻辑，就直接判断了 ··· 其实是我比较懒····

这样，一个squid的基本安装配置基本就成功了，可以找机器进行测试
后续，添加机器的话，可以进行直接部署了

    salt hostname state.highstate 或者 salt hostname state.sls squid