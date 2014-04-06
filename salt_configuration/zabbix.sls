zabbix-agent-ops:
  pkg:
    - installed
    
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /usr/local/zabbix-agent-ops/etc/zabbix_agentd.conf
      - file: /usr/local/zabbix-agent-ops/etc/zabbix_agentd.conf.d/nginx_status.conf
      - file: /usr/local/zabbix-agent-ops/etc/zabbix_agentd.conf.d/php-fpm_status.conf
      - file: /usr/local/zabbix-agent-ops/etc/zabbix_agentd.conf.d/squid_status.conf
      - file: /usr/local/zabbix-agent-ops/bin/nginx_status.sh
      - file: /usr/local/zabbix-agent-ops/bin/php-fpm_status.sh
      - file: /usr/local/zabbix-agent-ops/bin/squid_status.sh
      - pkg: zabbix-agent-ops



/usr/local/zabbix-agent-ops/etc/zabbix_agentd.conf:
  file.managed:
    - source: salt://files/zabbix/zabbix_agentd.conf
    - user: root
    - template: jinja
    - require:
      - pkg: zabbix-agent-ops


####################check_nginx###########################      
/usr/local/zabbix-agent-ops/bin/nginx_status.sh:
  file.managed:
    - source: salt://files/zabbix/nginx_status.sh
    - user: root
    - mode: 755
    - require:
      - pkg: zabbix-agent-ops
/usr/local/zabbix-agent-ops/etc/zabbix_agentd.conf.d/nginx_status.conf:
  file.managed:
    - source: salt://files/zabbix/nginx_status.conf
    - user: root
    - mode: 644
    - require:
      - pkg: zabbix-agent-ops

####################check_php-fpm###########################      
/usr/local/zabbix-agent-ops/bin/php-fpm_status.sh:
  file.managed:
    - source: salt://files/zabbix/php-fpm_status.sh
    - user: root
    - mode: 755
    - require:
      - pkg: zabbix-agent-ops
/usr/local/zabbix-agent-ops/etc/zabbix_agentd.conf.d/php-fpm_status.conf:
  file.managed:
    - source: salt://files/zabbix/php-fpm_status.conf
    - user: root
    - mode: 644
    - require:
      - pkg: zabbix-agent-ops

####################check_squid###########################      
/usr/local/zabbix-agent-ops/bin/squid_status.sh:
  file.managed:
    - source: salt://files/zabbix/squid_status.sh
    - user: root
    - mode: 755
    - require:
      - pkg: zabbix-agent-ops
/usr/local/zabbix-agent-ops/etc/zabbix_agentd.conf.d/squid_status.conf:
  file.managed:
    - source: salt://files/zabbix/squid_status.conf
    - user: root
    - mode: 644
    - require:
      - pkg: zabbix-agent-ops
