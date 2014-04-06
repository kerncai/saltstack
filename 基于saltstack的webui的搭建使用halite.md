salt的运维自动化，肯定不可能一直在终端执行命令去进行批量处理；salt本身提供了一个web ui，叫做halite。本质是在页面执行管理，后端使用的是saltstack api


----------
搭建过程：

    git clone https://github.com/saltstack/halite
克隆halite官方的源码

    cd halite/halite
    
    python genindex.py -C  # 生成index文件

安装salt-api，使用python的pip管理安装

首先安装pip管理

    wget  http://python-distribute.org/distribute_setup.py
    
    sudo python distribute_setup.py
    
    wget  https://github.com/pypa/pip/raw/master/contrib/get-pip.py
    
    sudo python get-pip.py

安装salt-api

    pip install salt-api
    pip install cherrypy

在master文件问添加：

    rest_cherrypy:
     host: 10.10.3.191
     port: 8080
     debug: true
     static: /halite/halite
     app: /halite/halite/index.html
    external_auth:
       pam:
         admin:
             - '*'
             - '@runner'
             - '@wheel'

启动:

    #python server_bottle.py -d -C -l debug -s cherrypy
    20140115_102828.079512 Bottle: Running web application server 'cherrypy' on 0.0.0.0:8080.
    20140115_102828.080180 Bottle: CORS is disabled.
    20140115_102828.080669 Bottle: TLS/SSL is disabled.
    20140115_102828.081155 Bottle: Server options: 
    {}
    Bottle v0.12-dev server starting up (using CherryPyServer())...
    Listening on http://0.0.0.0:8080/
    Hit Ctrl-C to quit.

debug模式 查看相关信息，可以得出是以0.0.0.0:8080端口启动的

直接salt-api -d启动

至此，halite搭建完成，可以通过http://localhost:8080去访问了

我这边是在服务器上面搭建的，线下不能直接访问http://localhost:8080,所以，添加到nginx进行转发

配置如下：

    [root@sa10-007 halite]# cat /etc/nginx/conf.d/salt.api.conf 
    server {
        listen 80;
        server_name 10.10.3.191;
        
        location / {
            proxy_pass http://0.0.0.0:8080;
        }
    }

这样 我就可以在线下直接访问http://10.10.3.191:80 就可以看到halite的web界面了

只不过，好像官方的这个halite看起来很纠结，页面操作各种不爽，准备通过api自己写ui了