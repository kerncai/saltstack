
SLS（代表SaLt State文件）是Salt State系统的核心。SLS描述了系统的目标状态，由格式简单的数据构成。这经常被称作配置管理
首先，在master上面定义salt的主目录，默认是在/srv/salt/下面，vim /etc/salt/master：

    file_roots:
       base:
         - /srv/salt
       dev:
        - /srv/salt-dev

然后，在/srv/salt下面创建top.sls文件(如果有的话，就不用创建了，直接编辑好了)
vim top.sls

    base:
      '*':
top.sls 默认从 base 标签开始解析执行,下一级是操作的目标，可以通过正则，grain模块,或分组名,来进行匹配,再下一级是要执行的state文件

    base:
      '*':               #通过正则去匹配所有minion
        - nginx          #这里都是我自己写的state.sls模块名 这里可以无视 后面会提到

      my_app:             #通过分组名去进行匹配 必须要定义match:nodegroup
        - match: nodegroup
        - nginx
    
      'os:Redhat':        #通过grains模块去匹配，必须要定义match:grain
        - match: grain
        - nginx

整个top.sls大概的格式就是这个样子，编写完top.sls后，编写state.sls文件；

    cd /srv/salt 
    vim nginx.sls
nginx.sls内容：

    nginx:
      pkg:               #定义使用（pkg state module）
        - installed      #安装nginx（yum安装）
      service.running:   #保持服务是启动状态
        - enable: True
        - reload: True
        - require:
          - file: /etc/init.d/nginx
        - watch:                 #检测下面两个配置文件，有变动，立马执行上述/etc/init.d/nginx 命令reload操作
          - file: /etc/nginx/nginx.conf
          - file: /etc/nginx/fastcgi.conf
          - pkg: nginx
    /etc/nginx/nginx.conf:       #绝对路径
      file.managed:
        - source: salt://files/nginx/nginx.conf  #nginx.conf配置文件在salt上面的位置
        - user: root
        - mode: 644
        - template: jinja   #salt使用jinja模块
        - require:
          - pkg: nginx
    
    /etc/nginx/fastcgi.conf:
      file.managed:
        - source: salt://files/nginx/fastcgi.conf 
        - user: root
        - mode: 644
        - require:
          - pkg: nginx

在当前目录下面（salt的主目录）创建files/nginx/nginx.conf、files/nginx/fastcgi.conf文件，里面肯定是你自己项配置的nginx配置文件的内容啦；使用salt做自动化，一般nginx都是挺熟悉的，这里不做详细解释了

测试安装：

    root@salt salt # salt 'sa10-003' state.sls nginx test=True
    ··········这里省略输出信息
    Summary
    ------------
    Succeeded: 8
    Failed:    0
    ------------
    Total:     8

往minion上面进行推送的时候，一般salt 'sa10-003' state.sls nginx 这种命令；当然，也可以执行
salt sa10-003 state.highstate 这种命令会默认匹配所有的state.sls模块。其中test=True 是指测试安装
 ，也就是不进行实际操作，只是查看测试效果。
 ---------- 
 state的逻辑关系列表：

include： 包含某个文件
比如我新建的一个my_webserver.sls文件内，就可以继承nginx和php相关模块配置，而不必重新编写

    root@salt salt # cat my_webserver.sls 
    include:
      - nginx
      - php
match: 配模某个模块，比如 之前定义top.sls时候的 match: grain match: nodegroup
require： 依赖某个state，在运行此state前，先运行依赖的state，依赖可以有多个
比如文中的nginx模块内，相关的配置必须要先依赖nginx的安装

    - require:
      - pkg: nginx
watch： 在某个state变化时运行此模块，文中的配置，相关文件变化后，立即执行相应操作

    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/fastcgi.conf
      - pkg: nginx
order： 优先级比require和watch低，有order指定的state比没有order指定的优先级高，假如一个state模块内安装多个服务，或者其他依赖关系，可以使用

    nginx:
      pkg.installed:
        - order:1
想让某个state最后一个运行，可以用last
