{% set apacheConfigAvDirectory = '/etc/apache2/conf-available/' %}
{% set apacheConfigEnDirectory = '/etc/apache2/conf-enabled/' %}


include:
  - webserver.admin_ips
  - webserver.conf
  - webserver.defaultvhost
  #- webserver.igbinary
  - webserver.modules

{%- if pillar['php_version'] == '5' %}
  - webserver.php5
{% else %}
  - webserver.php
{% endif %}
  #- webserver.pure-ftpd
  - webserver.unattended-upgrades
  - webserver.www-admin


apache2:
  pkg.installed: []
  service.running:
    - reload: True
    - require:
      - pkg: apache2


/root/salt/apache2autorestart.sh:
  file.managed:
    - source: salt://webserver/files/apache2autorestart.sh
    - makedirs: True

apache2autorestart_cron:
  cron.present:
    - identifier: apache2autorestart_cron
    - name: bash /root/salt/apache2autorestart.sh
    #Toutes les minutes
