include:
  - nginx
  - php

{{ pillar['ngx_conf_dir'] }}/conf.d:
  file.recurse:
    - source: salt://files/my_webserver/conf.d
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx
/home/www/indexes:
  file.recurse:
    - source: salt://files/my_webserver/my_indexes
    - user: evans
    - group: nginx
