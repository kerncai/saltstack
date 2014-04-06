############IDC################
{% if grains['ip_interfaces'].get('eth0')[0].startswith('10.10') %}
nameservers: ['10.10.6.251','10.10.6.252']
zabbixserver: ['10.10.3.234']
{% else %}
nameservers: ['10.20.100.75']
zabbixserver: ['10.20.100.234']
{% endif %}

############OS#################
{% if grains['os_family'] == 'Redhat' %}
vim: vim-enhanced
{% elif grains['os_family'] == 'Ubuntu' %}
vim: vim-nox
{% else %}
vim: vim-enhanced
{% endif %}

######## nginx,php,squid路径 ########
ngx_home_dir: /var/cache/nginx
ngx_conf_dir: /etc/nginx

php_home_dir: /opt/local/php-fpm
php_conf_dir: /opt/local/php-fpm/etc

squid_home_dir: /usr/local/squid-2.7
squid_conf_dir: /usr/local/squid-2.7/etc
######## 线上代码路径 ########
code_dir: /home/www/v2
