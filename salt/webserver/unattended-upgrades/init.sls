unattended-upgrades:
  pkg:
    - installed

#holdpkgs:
#  cmd.run:
#    - name: apt-mark hold apache2* mysql* php-* php{{ pillar['php_apt_version'] }}* linux-image* linux-headers*

/etc/apt/apt.conf.d/20auto-upgrades:
  file:
    - managed
    - source: salt://webserver/unattended-upgrades/files/20auto-upgrades
    - require:
      - pkg: unattended-upgrades

/etc/apt/apt.conf.d/50unattended-upgrades:
  file:
    - managed
    - source: salt://webserver/unattended-upgrades/files/50unattended-upgrades
    - require:
      - pkg: unattended-upgrades
