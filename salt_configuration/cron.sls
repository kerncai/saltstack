date > /tmp/crontest:
  cron.present:
    - user: root
    - minute: '*/1'
