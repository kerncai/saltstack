---
layout: post
title: salt master 配置文件选项说明
keywords: codepiano
description: salt master 配置文件选项说明
categories: [tech, sa]
tags: [linux, tech, salt]
group: archive
icon: globe
---
{% include codepiano/setup %}

原文出处:http://blog.coocla.org/301.html

Salt系统的配置是令人惊讶的简单，对于salt的两个系统都有各自的配置文件，salt-master是通过一个名为master的文件配置，salt-minion是通过一个名为minion的文件配置。 salt-master的配置文件位于/etc/salt/master,可用选项如下：

interface
默认接口：0.0.0.0（所有的网络地址接口）
绑定到本地的某个网络接口

    interface: 192.168.0.1


publish_port

默认值：4505

设置master与minion的认证通信端口

    publish_port: 4505

user

默认值：root

运行salt进程的用户

    user: root

max_open_files

默认值：100000

每一个minion连接到master，至少要使用一个文件描述符，如果足够多的minion连接到master上，你将会从控制台上看到

    salt-master crashes：
    Too many open files (tcp_listener.cpp:335)
    Aborted (core dumped)

默认值这个值取决于ulimit -Hn的值，即系统的对打开文件描述符的硬限制

如果你希望重新设置改值或者取消设置，记住这个值不能超过硬限制，提高硬限制取决于你的操作系统或分配，一个好的方法是internet找到对应操作系统的硬限制设置，比如这样搜索：

    raise max open files hard limit debian

    max_open_files: 100000

    worker_threads

默认值：5

启动用来接收或应答minion的线程数。如果你有很多minion，而且minion延迟你的应答，你可以适度的提高该值. 在点对点的系统环境中使用时，该值不要被设置为3以下，但是可以将其设置为1

    worker_threads: 5

ret_port

默认值：4506

这个端口是master用来发送命令或者接收minions的命令执行返回信息

    ret_port: 4506

pidfile

    默认值：/var/run/salt-master.pid

指定master的pid文件位置

    pidfile: /var/run/salt-master.pid

root_dir

默认值：/

指定该目录为salt运行的根目录，改变它可以使salt从另外一个目录开始运行，好比chroot

root_dir: /

pki_dir

默认值：/etc/salt/pki

这个目录是用来存放pki认证秘钥

    pki_dir: /etc/salt/pki

cachedir

默认值：/var/cache/salt

这个目录是用来存放缓存信息，特别是salt工作执行的命令信息

    cachedir: /var/cache/salt

keep_jobs

默认值：24

设置保持老的工作信息的过期时间，单位小时
job_cache

默认值：True

设置master维护的工作缓存，这是一个很好的功能，当你的Minons超过5000台时，他将很好的承担这个大的架构，关闭这个选项，之前的工作执行以及工作系统将无法被利用，一般不推荐关掉改选项，开启改选项将会是很明智的，他将使master获得更快的IO系统
ext_job_cache

默认值：''

对所有的minions使用指定的默认值returner，当使用了这个参数来指定一个returner并且配置正确，minions将会一直将返回的数据返回到returner，这也会默认值禁用master的本地缓存

    ext_job_cache: redis

minion_data_cache

默认值：True

minion data cache是关于minion信息存储在master上的参数，这些信息主要是pillar 和 grains数据.这些数据被缓存在cachedir定义的目录下的minion目录下以minion名为名的目录下并且预先确定哪些minions将从执行回复

    minion_cache_dir: True

enforce_mine_cache

默认值：False

默认情况下当关闭了minion_data_cache，mine将会停止工作，因为mine是基于缓存数据，通过启用这个选项，我们将会显示的开启对于mine系统的缓存功能

    enforce_mine_cache: False

sock_dir

默认值：/tmp/salt-unix

指定unix socket主进程通信的socket创建路径
master的安全配置
open_mode

默认值：False

open_mode是一个危险的安全特性，当master遇到pki认证系统，秘钥混淆和身份验证失效时，打开open_mode，master将会接受所有的身份验证。这将会清理掉pki秘钥接受的minions。通常情况下open_mode不应该被打开，它只适用于短时间内清理pki keys，若要打开它，可将值调整为True

    open_mode: False

auto_accept

默认值：False

开启auto_accept。这个设置将会使master自动接受所有发送公钥的minions

    auto_accept: True

autosign_file

默认值：/etc/salt/autosign.conf

如果autosign_file的值被指定，那么autosign_file将会通过该输入允许所有的匹配项，首先会搜索字符串进行匹配，然后通过正则表达式进行匹配。这是不安全的

    autosign_file: /etc/salt/autosign.conf

client_acl

默认值：{}

开启对系统上非root的系统用户在master上执行特殊的模块，这些模块名可以使用正则表达式进行表示

    client_acl:
      fred:
          - test.ping
          - pkg.*

client_acl_blacklist

默认值：{}

黑名单用户或模块

这个例子表示所有非sudo用户以及root都无法通过cmd这个模块执行命令，默认情况改配置是完全禁用的

    client_acl_blacklist:
      users:
          - root
          - '^(?!sudo_).*$'    # all non sudo users
      modules:
          - cmd

external_auth

默认值：{}

salt的认证模块采用外部的认证系统用来做认证和验证用户在salt系统中的访问区域

    external_auth:
      pam:
          fred:
              - test.*

token_expire

默认：43200

新令牌生成的时间间隔，单位秒，默认是12小时

    token_expire: 43200

file_recv

默认值：False

允许minions推送文件到master上，这个选项默认是禁用的，出于安全考虑

    file_recv: False

master模块管理
runner_dirs

默认值：[] 设置搜索runner模块的额外路径

    runner_dirs: []

cython_enable

默认值：False

设置为true来开启对cython模块的编译

    cython_enable: False

master状态系统设置
state_verbose

默认：False

state_verbose允许从minions返回更多详细的信息，通常清空下只返回失败或者已经更改，但是将state_verbose设置为True,将会返回所有的状态检查

    state_verbose: True

state_output

默认值：full

state_output的设置将会改变信息输出的格式，当被设置为”full”时，将全部的输出一行一行的显示输出；当被设置为”terse“时，将会被缩短为一行进行输出；当被设置为”mixed”时，输出样式将会是简洁的，除非状态失败，这种情况下将会全部输出；当被设置为”change”时，输出将会完全输出除非状态没有改变

    state_output: full

state_top

默认值：top.sls

状态系统使用一个入口文件告诉minions在什么环境下使用什么模块，这个状态入口文件被定义在基础环境的相对根路径下

    state_top: top.sls

external_nodes

默认值：None

这个外部节点参数允许salt来收集一些数据，通常被放置在一个入口文件或外部节点控制器.外部节点的选择是可执行的，将会返回ENC数据，记住如果两者都启用的话salt会将外部节点和入口文件的结果进行综合汇总。

    external_nodes: cobbler-ext-nodes

renderer

默认值：yaml_jinja

使用渲染器用来渲染minions的状态数据

    renderer: yaml_jinja

failhard

默认值：False

设置一个全局的failhard表示，当单个的状态执行失败后，将会通知所有的状态停止运行状态

    failhard: False

test

默认值：False

如果真的要作出改变或者仅仅通知将要执行什么改变时设置所有的状态调用为test

    test: False

master文件服务器设置
fileserver_backend

默认值：

    fileserver_backend:
      - roots

salt支持模块化的后端文件系统服务器，它允许salt通过第三方的系统来管理收集文件并提供给minions使用，可以配置多个后端文件系统，这里支持gitfs、hgfs、roots、s3fs文件调用的搜索顺序按照后台文件系统的配置顺序来搜索，默认的设置只开启了标准的后端服务器roots，具体的根选项配置通过file_roots参数设置

    fileserver_backend:
      - roots
      - gitfs

file_roots

默认值：

    base:
      - /srv/salt

salt运行一个轻量级的文件服务器通过ZeroMQ对minions进行文件传输，因此这个文件服务器是构造在master的守护进程中，并且不需要依赖于专用的端口 文件服务器的工作环境传递给master，每一个环境可以有多个跟目录，但是相同环境下多个文件的子目录不能相同，否则下载的文件将不能被可靠的保证，一个基础环境依赖于主的入口文件，如：

    file_roots:
      base:
         - /srv/salt
      dev:
         - /srv/salt/dev/services
         - /srv/salt/dev/states
      prod:
         - /srv/salt/prod/services
         - /srv/salt/prod/states

hash_type

默认值：md5

hash_type是用来当发现在master上需要对一个文件进行hash时的hash使用的算法，默认是md5.但是它也支持sha1,sha224,shar256,shar384,shar512

    hash_type: md5

file_buffer_size

默认值：1048576

文件服务器的缓存区大小

    file_buffer_size: 1048576

pillar配置
pillar_roots

默认值：

    base:
      - /srv/pillar

设置不同的环境对应的存放pillar数据的目录，这个配置和file_roots参数配置一样

    pillar_roots:
      base:
         - /srv/pillar
      dev:
         - /srv/pillar/dev
      prod:
          - /srv/pillar/prod

ext_pillar

当进行pillar数据收集时，这个ext_pillar参数允许调用任意数量的外部pillar接口，这个配置是基于ext_pillar函数，你可以从这个找到这个函数https://github.com/saltstack/salt/blob/develop/salt/pillar

默认情况下，这个ext_pillar接口没有配置运行

默认值：None

    ext_pillar:
      - hiera: /etc/hiera.yaml
      - cmd_yaml: cat /etc/salt/yaml
      - reclass:
         inventory_base_uri: /etc/reclass

从这里可以查到pillar的一些额外细节
syndic server配置

syncdic是salt master用来通过从整体架构中高于自己层级的master或者syndic接收命令传递给minions的中间角色。使用syndic非常简单，如果这个master在整体架构中，他的下级存在syndic server，那么需要将master的配置文件中的”order_master”值设置为True，如果这个master还需要运行一个syndic进程，扮演另外一个角色，那么需要设置主master server的信息(上一级master)

千万别忘记了，这将意味着它将与其他master共享它的minion的id和pki_dir
order_masters

默认值：False

当额外的数据需要发送和传递，并且这个master控制的minions是被低等级的master或syndic直接管理下，那么”order_masters”这个值必须得设置为True

    order_master: False

syndic_master

默认值：None

如果这个master运行的salt-syndic连接到了一个更高层级的master,那么这个参数需要配置成连接到的这个高层级的master的地址

    syndic_master: masterofmasters

syndic_master_port

默认值：4506

如果这个master运行的salt-syndic连接到了一个更高层级的master,那么这个参数需要配置成连接到的这个高层级master的监听端口

    syndic_master_port: 4506

syndic_log_file

默认值：syndic.log

为syndic进程指定日志文件

    syndic_log_file: salt-syndic.log

syndic_pidfile

默认值：salt-syndic.pid

为syndic进程指定pid文件

    syndic_pidfile: syndic.pid

Peer Publish设置

salt minions可以向其他minions发送命令，但是仅仅在minion允许的情况下。默认情况下”Peer Publication”是关闭的，当需要开启的时候，需要开启对应的minion和对应的命令，这样可以允许根据个人的minions安全的划分出命令
peer

默认值：{}

这个配置使用正则表达式去匹配minions并且是一个正则表达式列表函数，下面这个例子将允许名为foo.example.com的minion认证通过后执行test和pkg模块中的函数

    peer:
      foo.example.com:
         - test.*
         - pkg.*

这将允许所有的minion执行所有的命令

    peer:
      .*:
         - .*

这样的配置是极不推荐的，因为任何人得到架构中的任何一个minion即可拥有所有的minions，这是不安全的
peer_run

默认值：{}

peer_run参数是用来打开runners在master所允许的minions上，peer_run的配置匹配格式和peer参数的配置一样 下面这个例子允许foo.example.com的minion执行manage.up runner

    peer_run:
      foo.example.com:
         - manage.up

nodegroups

默认值：{}

minions允许通过node groups来分成多个逻辑组，每个组由一个组名和复合模式组成

    nodegroups:
      group1: 'L@foo.domain.com,bar.domain.com,baz.domain.com or bl*.domain.com'
      group2: 'G@os:Debian and foo.domain.com'

Master日志设置
log_file

默认值：/var/log/salt/master

master的日志可以发送到一个普通文件，本地路径名或者网络位置，更多详情请访问 http://docs.saltstack.com/ref/configuration/logging/index.html#std:conf-log-log_file

例如：

    log_file: /var/log/salt/master
    log_file: file:///dev/log
    log_file: udp://loghost:10514

log_level

默认值：warning

按照日志级别发送信息到控制台，更多详情请访问 http://docs.saltstack.com/ref/configuration/logging/index.html#std:conf-log-log_level

    log_level: warning
    
    log_level_logfile

默认值：warning

按照日志级别发送信息到日志文件，更多详情请访问 http://docs.saltstack.com/ref/configuration/logging/index.html#std:conf-log-log_level_logfile

    log_level_logfile: warning

log_datefmt

默认值：%H:%M:%S

发送到控制台信息所用的日期时间格式，更多详情请访问 http://docs.saltstack.com/ref/configuration/logging/index.html#std:conf-log-log_datefmt

    log_datefmt: '%H:%M:%S'

log_datefmt_logfile

默认值: %Y-%m-%d %H:%M:%S

发送到日志文件信息所用的日期时间格式，更多详情请访问 http://docs.saltstack.com/ref/configuration/logging/index.html#std:conf-log-log_datefmt_logfile

    log_datefmt_logfile: '%Y-%m-%d %H:%M:%S'

log_fmt_console

默认值: [%(levelname)-8s] %(message)s

控制台日志信息格式，更多详情请访问 http://docs.saltstack.com/ref/configuration/logging/index.html#std:conf-log-log_fmt_console

    log_fmt_console: '[%(levelname)-8s] %(message)s'

log_fmt_logfile

默认值: %(asctime)s,%(msecs)03.0f [%(name)-17s][%(levelname)-8s] %(message)s

%(asctime)s：2003-07-08 16:49:45

%(msecs)03.0f：当前时间的毫秒部分

%(name)：日志记录调用器的名字

%(levelname)：日志记录级别

%(message)s：日志详细信息

日志文件信息格式，更多详情请访问 http://docs.saltstack.com/ref/configuration/logging/index.html#std:conf-log-log_fmt_logfile

    log_fmt_logfile: '%(asctime)s,%(msecs)03.0f [%(name)-17s][%(levelname)-8s] %(message)s'

log_granular_levels

默认值：{}

这可以更加具体的控制日志记录级别，更多详情请访问 http://docs.saltstack.com/ref/configuration/logging/index.html#std:conf-log-log_granular_levels
Include 配置

    default_include

默认值：master.d/*.conf

master可以从其他文件读取配置，默认情况下master将自动的将master.d/*.conf中的配置读取出来并应用，其中master.d目录是相对存在于主配置文件所在的目录
include

默认值：not defined

master可以包含其他文件中的配置，要启用此功能，通过此参数定义路径或文件，此路径可以是相对的也可以是绝对的，相对的，会被看作相对于主配置文件所在的目录，路径中还可以使用类似于shell风格的通配符，如果没有文件匹配的路径传递给此选项，那么master将会在日志中记录一条警告的消息

 

    # Include files from a master.d directory in the same
        # directory as the master config file
        include: master.d/*
    
    # Include a single extra file into the configuration
    include: /etc/roles/webserver
    
    # Include several files and the master.d directory
    include:
      - extra_config
      - master.d/*
      - /etc/roles/webserver

