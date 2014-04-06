salt-minion:
  pkg:
    - installed
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/salt/minion

/etc/salt/minion:
  file.managed:
    - source: salt://files/salt-minion/minion
    - user: root
    - mode: 644
    - require:
      - pkg: salt-minion
