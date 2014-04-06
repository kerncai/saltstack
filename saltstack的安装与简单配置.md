---
layout: post
title: saltstack运维自动化-安装
keywords: codepiano
description: saltstack 运维自动化-安装
categories: [tech, sa]
tags: [linux, tech, salt]
group: archive
icon: globe
---
{% include codepiano/setup %}


<p class="paragraph">
之前使用puppet，各种笨重、各种不爽；之后有看过chef、ansible等，一直没啥兴趣；后面发现了saltstack后，一见钟情。
</p>
优点：

 1. 首先，他速度快，基于消息队列+线程，跑完多台设备，都是毫秒级别的
 2. 其次，非常灵活，源码是python，方便理解和自定义模块（python 语言相对于其他的perl、ruby等还是很好理解的）
 3. 命令简单，功能强大

</p>

一、salt-master的安装
-------------------

<p class="paragraph">
centos、redhat等系统的安装：</p>

 

    现在centos下的yum源内有最新的salt-master源码包，安装的话，直接
    yum install salt-master -y #服务端
    yum install salt-minion -y #客户端

<p class="paragraph">
ubuntu下的安装:</p>

    13.04的软件源收录有salt，版本比较老0.12.0版本。但是13.04以下的版本并没有收录，需要添加PPA源
    sudo apt-get install salt-master #服务端
    sudo apt-get install salt-minion #客户端

<p class="paragraph">
13.04以下的版本，需要手工添加ppa源，才可以用包管理器安装saltstack:</p>

    sudo apt-get install python-software-properties
    echo deb http://ppa.launchpad.net/saltstack/salt/ubuntu `lsb_release -sc` main | sudo tee    
    /etc/apt/sources.list.d/saltstack.list
    wget -q -O- "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4759FA960E27C0A6" |sudo apt-key add -
    sudo apt-get update
    sudo apt-get install salt-master
    sudo apt-get install salt-minion


----------


二、配置
-------------
<p class="paragraph">
server端的配置：vim /etc/salt/master (master的配置文件时默认在这条目录下面的)</p>
    user: root
    auto_accept: True #自动接收minion端的key并验证
    /etc/init.d/salt-master restart 
<p class="paragraph">
minion端的配置: vim /etc/salt/minion (minion配置文件的默认路径)</p>

    master: salt (这里填写的是服务端的hostname，我的server名字就是salt)
    /etc/init.d/salt-minion restart 
salt minion和master的认证过程：

minion在第一次启动时，会在/etc/salt/pki/minion/下自动生成minion.pem(private key), minion.pub(public key)，然后将minion.pub发送给master
master在接收到minion的public key后，通过salt-key命令accept minion public key，这样在master的/etc/salt/pki/master/minions下的将会存放以minion id命名的public key, 然后master就能对minion发送指令了

来到master端:

    #salt-key -L # 验证minion的key是否接收
    Accepted Keys:
    sa10-007
    Unaccepted Keys:
    Rejected Keys:
可以发现，是正常接收到minion端(sa10-007)的key；这里的自动接收起源于上文提到的auto_accept: True这个参数，这个参数开启，表示只要有minion起来就会自动被salt的server端所接收

salt-key的基本命令：

    salt-key -L #检测当前server端所有minion端key的情况，三种：接收、等待接收和拒绝
    salt-key -a hostname #指定接收某台minion的key
    salt-key -A #接收Unaccepted Keys下所有的minion
    salt-key -d hostname #删除已经接收的机器中指定机器minion key (Accepted Keys:)
    salt-key -D #删除已经接收的所有机器(Accepted Keys:)

验证server和minion的通信（server端进行）：

    #salt '*' test.ping
    sa10-007:
     True
可以发现，server端和minion端是可以正常通信的，至此，saltstack的master和minion正常安装以及配置完成
，后续 将整理salt的基本使用