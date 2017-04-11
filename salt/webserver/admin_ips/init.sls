
/etc/apache2/admin_ips.conf:
  file:
    - managed           
    - source: salt://webserver/admin_ips/files/admin_ips.conf
    - template: jinja

/etc/apache2/admin_ips_offices.conf:
  file:
    - managed
    - source: salt://webserver/admin_ips/files/admin_ips_offices.conf


/etc/apache2/prestataire_ips.conf:
  file:
    - managed
    - source: salt://webserver/admin_ips/files/prestataire_ips.conf


/etc/apache2/admin_ips_servers_generated.conf:
  file:
    - managed
    - source: salt://webserver/admin_ips/files/admin_ips_servers_generated.conf


/etc/apache2/admin_ips_servers_static.conf:
  file:
    - managed
    - source: salt://webserver/admin_ips/files/admin_ips_servers_static.conf



/etc/apache2/admin_access.conf:
  file:
    - managed
    - source: salt://webserver/admin_ips/files/admin_access.conf

