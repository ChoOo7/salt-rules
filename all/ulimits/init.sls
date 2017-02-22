

/etc/security/limits.conf:
  file:
    - managed           
    - source: salt://all/ulimits/files/limits.conf
