yum:
  pkg:
    - installed
/etc/yum.repos.d/:
  file.recurse:
    - source: salt://files/system/yum.repos.d
