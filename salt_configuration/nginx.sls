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

{{ pillar['ngx_conf_dir'] }}/nginx.conf:
  file.managed:
    - source: salt://files/nginx/nginx.conf 
    - user: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: nginx

{{ pillar['ngx_conf_dir'] }}/fastcgi.conf:
  file.managed:
    - source: salt://files/nginx/fastcgi.conf 
    - user: root
    - mode: 644
    - require:
      - pkg: nginx

/etc/init.d/nginx:
  file.managed:
    - source: salt://files/nginx/nginx.ini
    - user: root
    - mode: 755
    - require:
      - pkg: nginx

/data1/logs/nginx:
  file.directory:
    - user: root
    - mode: 755
    - makedirs: True
    - require:
      - pkg: nginx
