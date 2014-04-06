

前提：操作在master在进行
minion id minion的唯一标示。默认情况minion id是minion的主机名(FQDN)，你可以通过id来指定minion的名字.
salt默认使用shell样式，当然也可以在states.sls中定义。本文主要记录的是匹配minion，以为只有正确的匹配，才是你以后批量管理机器的前提。

匹配当前所有的minion：

    root@salt ~ # salt '*' test.ping
    cdn20-002:
      True
    cdn20-001:
        True
    app10-104:
        True
    cdn20-003:
        True
    其中 '*' 是匹配当前saltmaster接收到所有minion客户端；test.ping是salt默认的验证通信命令
匹配以cdn开头的所有机器:

    root@salt ~ # salt 'cdn*' test.ping
    cdn20-002:
        True
    cdn20-005:
        True
    cdn20-004:
        True
    cdn20-001:
        True
    cdn20-003:
        True
匹配cdn20-001/004的机器：

    root@salt ~ # salt 'cdn20-00[1-4]' test.ping
    cdn20-002:
        True
    cdn20-001:
        True
    cdn20-003:
        True
    cdn20-004:
        True
minion也可以通过Perl-compatible正则表达式进行匹配.匹配cdn和sa的机器

    root@salt ~ # salt -E 'cdn|sa' test.ping
    cdn20-005:
        True
    cdn20-002:
        True
    sa10-003:
        True
    cdn20-004:
        True
    cdn20-001:
        True
    cdn20-003:
        True
指定特定的机器进行匹配，比如，我想匹配cdn20-002\cdn20-004：

    root@salt ~ # salt -L 'cdn20-002,cdn20-004' test.ping
    cdn20-002:
        True
    cdn20-004:
        True


----------
自定义组进行匹配：
----
使用组进行匹配的前提，必要要在master里面定于组的相关信息

    root@salt ~ # vim /etc/salt/master.d/nodegroups.conf         
    master.d之前的记录已经介绍过，在master里面开启default_include: master.d/*.conf
    root@salt ~ # cat /etc/salt/master.d/nodegroups.conf 
    nodegroups:
      my_app: 'app10-091'
      squid_20: 'cdn20-*'
      mendian: 'app10-114'
      person: 'L@app10-112,app10-113'
查看squid_20这个组的相关信息：

    root@salt ~ # salt -N 'squid_20' test.ping
    cdn20-002:
        True
    cdn20-005:
        True
    cdn20-004:
        True
    cdn20-003:
        True
    cdn20-001:
        True




