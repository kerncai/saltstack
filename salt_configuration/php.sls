php:
  pkg:
    - name: ajk-phpfpm
    - installed
  user.present:
    - name: php-fpm
    - home: {{ pillar['php_home_dir'] }}
    - shell: /sbin/nologin
    - require:
      - group: php-fpm
  group.present:
    - name: php-fpm
    - require:
      - pkg: ajk-phpfpm
  service.running:
    - name: php-fpm
    - enable: True
    - reload: True
    - watch:
      - file: {{ pillar['php_conf_dir'] }}/pear.conf
      - file: {{ pillar['php_conf_dir'] }}/php.ini
      - file: {{ pillar['php_conf_dir'] }}/php-fpm.conf
      - pkg: ajk-phpfpm

{{ pillar['php_conf_dir'] }}/pear.conf:
  file.managed:
    - source: salt://files/php/pear.conf
    - user: root
    - mode: 644
    - require:
      - pkg: ajk-phpfpm

{{ pillar['php_conf_dir'] }}/php.ini:
  file.managed:
    - source: salt://files/php/php.ini
    - user: root
    - mode: 644
    - require:
      - pkg: ajk-phpfpm

{{ pillar['php_conf_dir'] }}/php-fpm.conf:
  file.managed:
    - source: salt://files/php/php-fpm.conf
    - user: root
    - mode: 644
    - require:
      - pkg: ajk-phpfpm

