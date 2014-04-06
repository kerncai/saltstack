python:
  pkg:
    - installed
    - name: ajk-python

/root/init-python/setuptools-1.4.2.tar.gz:
  file.managed:
    - source: salt://files/python/setuptools-1.4.2.tar.gz
    - require: 
      - pkg: python

/root/init-python/pip-2.7:
  file.managed:
    - source: salt://files/python/pip-2.7
    - mode: 755
    - require: 
      - pkg: python

/root/init-python/virtualenv-2.7:
  file.managed:
    - source: salt://files/python/virtualenv-2.7
    - mode: 755
    - require: 
      - pkg: python

/root/init-python/init-python.sh:
  cmd.run:
    - prereq:
      - file: /root/init-python/init-python.sh
    - unless: python2.7 -m pip && python2.7 -m virtualenv
  file.managed:
    - source: salt://files/python/init-python.sh
    - mode: 755
    - require: 
      - pkg: python
