include:
  - inc.resolv
  - inc.yum
  - inc.vim

ssh:
  pkg:
    - installed
    - name: openssh-server
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://files/system/sshd_config
    - user: root
    - mode: 600
    - require:
      - pkg: ssh
  service.running:
    - name: sshd
    - enable: True
    - reload: True
    - watch:
      - file: ssh
      - pkg: ssh

key:
  file.managed:
    - name: /root/.ssh/authorized_keys
    - source: salt://files/system/root_ssh_keys
    - user: root
    - mode: 600

motd:
  file.managed:
    - name: /root/motd.sh
    - source: salt://files/system/motd.sh
    - user: root
    - mode: 755
  cmd.run:
    - name: /root/motd.sh
    - user: root
    - watch:
      - file: /root/motd.sh

sudo:
  file.managed:
    - name: /etc/sudoers
    - source: salt://files/system/sudoers
    - user: root
    - mode: 440

iptables:
  service:
    - dead

syslog:
  pkg:
    - installed
    - name: sysklogd
  file.managed:
    - name: /etc/syslog.conf
    - source: salt://files/system/syslog.conf
    - user: root
    - mode: 644
  service.running:
    - name: syslog
    - enable: True
    - reload: True
    - watch:
      - file: syslog
      - pkg: syslog
