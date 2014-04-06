vim:
  pkg:
    - installed
    - name: {{ pillar['vim'] }}
  file.managed:
    - name: /root/.vimrc
    - source: salt://files/system/vimrc
    - user: root
    - mode: 644
    - require:
      - pkg: vim
