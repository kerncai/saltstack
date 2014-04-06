Pillar是Salt非常重要的一个组件，它用于给特定的minion定义任何你需要的数据，这些数据可以被Salt的其他组件使用。这里可以看出Pillar的一个特点，Pillar数据是与特定minion关联的，也就是说每一个minion都只能看到自己的数据，所以Pillar可以用来传递敏感数据（在Salt的设计中，Pillar使用独立的加密session，也是为了保证敏感数据的安全性）。
另外还可以在Pillar中处理平台差异性，比如针对不同的操作系统设置软件包的名字，然后在State中引用等。

定义pillar数据
----

默认情况下，master配置文件中的所有数据都添加到Pillar中，且对所有minion可用。默认如下：

    #pillar_opts: True
master上配置文件中定义pillar_roots，用来指定pillar的数据存储在哪个目录

    pillar_roots:
       base:
        - /srv/salt/pillar

首先，和state系统一样，pillar也是需要一个top.sls文件作为一个入口，用来指定对象。

    base:
      '*':
        - pillar #这里指定了一个pillar模块
pillar.sls文件：

    ############IDC################
    {% if grains['ip_interfaces'].get('eth0')[0].startswith('10.10') %}
    nameservers: ['10.10.9.31','10.10.9.135']
    zabbixserver: ['10.10.9.234']
    {% else %}
    nameservers: ['10.20.9.75']
    zabbixserver: ['10.20.9.234']
    {% endif %}
    
    ######## nginx ########
    ngx_home_dir: /var/cache/nginx

上文的IDC这块是我自己整理的通过ip来划分不同的nameserver等，这里只是放出来参考，在State文件中将可以引用Pillar数据，比如引用ngx_home_dir: 

    nginx:
      pkg:
        - installed
      user.present:
        - home: {{ pillar['ngx_home_dir'] }}
        - shell: /sbin/nologin
        - require:
          - group: nginx
      group.present:
        - require:
          - pkg: nginx
      service.running:
        - enable: True
        - reload: True
        - require:
          - file: /etc/init.d/nginx
          - file: /data1/logs/nginx
        - watch:
          - file: {{ pillar['ngx_conf_dir'] }}/nginx.conf
          - file: {{ pillar['ngx_conf_dir'] }}/fastcgi.conf
          - pkg: nginx
    
    ······ 后面关于配置就省略了 

在pillar内可以提前将不同的部分根据在pillar内定义好，这样统一配置的时候就可以实现根据机器实际情况配置；比如根据机器的硬件情况配置nginx的worker_processes:

    user nginx;
    {% if grains['num_cpus'] < 8 %}
    worker_processes {{ grains['num_cpus'] }};
    {% else %}
    worker_processes 8;
    {% endif %}
    worker_rlimit_nofile 65535;
    ``````````具体配置省略

很多定义的时候，都可以使用到pillar来进行自定义相关数据，具体情况可以自行摸索，这里只是个举例。