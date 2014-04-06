grains.items主要用来收集minion端的信息，方便进行信息采集，后续的piller使用，根据硬件信息自动匹配配置文件等。
基本用法
-----
grains.ls

    salt '*' grains.ls 显示所有minion的item
    
grains.items

    salt '*' grains.items 显示所有minion的item值

grains.item

    salt '*' grains.item os 显示os的相关信息。如下 ：
    root@salt ~ # salt 'sa10-003' grains.item os
    sa10-003:
      os: RedHat
如果想同时获取多个item，可以在后面接空格后，直接相关item，如下：

    root@salt ~ # salt 'sa10-003' grains.item os osrelease oscodename
    sa10-003:
      os: RedHat
      oscodename: Tikanga
      osrelease: 5.8
      


----------


自定义grains：
首先，现在salt的根目录下(/srv/salt)建一个目录_grains

    mkdir /srv/salt/_grains
    cd /srv/salt/_grains
假设我要取minion端内存的信息 事例如下：
vim mem.py

    # -*- coding: utf-8 -*-
    
    '''
    Module for squid disk information by python
    '''
    import commands
    import os
    
    def cache():
        '''
        Return the memory usage information for volumes mounted on this minion
        '''
        grains={}
        m = commands.getoutput("free -g|awk '$0~/Mem/ {print$2+1}'")
        grains['mem_test']=int(m)
    
        return grains


同步到minion端

    root@salt _grains # salt 'sa10-003' saltutil.sync_all 
    sa10-003:
        ----------
        grains:
            - grains.mem #已经同步过来了
        modules:
        outputters:
        renderers:
        returners:
        states:
如果需要更改模块，更改完成后，可以使用下面命令重载:

    salt sa10-003 sys.reload_modules
验证下之前的自定义grains：

    root@salt _grains # salt sa10-003 grains.item mem_test
    sa10-003:
      mem_test: 2
sa10-003的内存信息：

    [root@sa10-003 salt]# free -m
                 total       used       free     shared    buffers     cached
    Mem:          2012       1766        246          0        286       1207
    -/+ buffers/cache:        272       1739
    Swap:            0          0          0
在saltmaster上面自定义grains取到的信息和本机是一致的


----------
除了salt自带和我们自定义的items可以取到系统信息之外，我们还可以使用shell命令在来达到目的；当然，这需要salt的另外一个强大的命令，cmd.run
我要取sa10-003的内存信息，可以使用下面的命令：

    root@salt _grains # salt sa10-003 cmd.run 'free -m'
    sa10-003:
                     total       used       free     shared    buffers     cached
        Mem:          2012       1769        242          0        286       1207
        -/+ buffers/cache:        275       1736
        Swap:            0          0          0

cmd.run在master端进行操作，后面跟着的是系统相关的shell命令，这种方式，可以实现minion端几乎所有的命令。

