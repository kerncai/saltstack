squid:
  pkg:
    - name: ajk-squid
    - installed
  user.present:
  - home: {{ pillar['squid_home_dir'] }}
  - shell: /sbin/nologin
  - require:
    - group: squid
  group.present:
    - name: squid
    - require:
      - pkg: ajk-squid
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/init.d/squid
    - watch:
      - file: {{ pillar['squid_conf_dir'] }}/squid.conf

/etc/init.d/squid:
  file.managed:
    - source: salt://files/squid/squid
    - user: root
    - mode: 755
    - require:
      - pkg: ajk-squid
/root/scripts/rm_cache_swap_log.sh:
  file.managed:
    - source: salt://files/squid/rm_cache_swap_log.sh
    - user: root
    - mode: 755

/var/spool/cron/root:
  file.managed:
    - source: salt://files/squid/root
    - user: root
    - mode: 644

/etc/logrotate.d/squid:
  file.managed:
    - source: salt://files/squid/squid_log
    - user: root
    - mode: 644

{{ pillar['squid_conf_dir'] }}/squid.conf:
  file.managed:
    - source: salt://files/squid/squid.conf
    - user: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: ajk-squid
