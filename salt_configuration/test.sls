/tmp/hosts:
  file.comment:
    - backup: .saltbak
    - regex: ^127.0.0.1

/tmp/tmp2/hosts:
  file.copy:
    - source: /tmp/hosts
    - makedirs: True
    - require:
      - file: /tmp/hosts
