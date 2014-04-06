include:
  - python

/opt/virtualenv:
  virtualenv.managed:
    - pip_bin: /usr/bin/virtualenv-2.7
    - system-site-package: False
    #- requirements: salt://files/virtualenv/REQ.txt
    - require:
      - sls: python

