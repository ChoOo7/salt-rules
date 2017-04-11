serviceinstallpureftpd:
  pkg.installed:
    - pkgs:
      - pure-ftpd

/etc/pure-ftpd/conf/PassivePortRange:
  file:
    - managed
    - source: salt://webserver/pure-ftpd/files/PassivePortRange
    - template: jinja
    - require:
      - pkg: installpureftpd

/etc/pure-ftpd/conf/ForcePassiveIP:
  file:
    - managed
    - source: salt://webserver/pure-ftpd/files/ForcePassiveIP
    - template: jinja
    - require:
      - pkg: installpureftpd

restart-pure-ftpd:
  service.running:
    - name: pure-ftpd
    - listen:
      - file: /etc/pure-ftpd/conf/PassivePortRange
      - file: /etc/pure-ftpd/conf/ForcePassiveIP
    - require:
      - pkg: installpureftpd
