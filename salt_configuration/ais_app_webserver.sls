include:
  - nginx
  - php

{{ pillar['ngx_conf_dir'] }}/conf.d:
  file.recurse:
    - source: salt://files/ais_app_webserver/conf.d
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx
