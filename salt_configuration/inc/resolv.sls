resolv:
  file.managed:
    - name: /etc/resolv.conf
    - source: salt://files/system/resolv.conf
    - template: jinja
