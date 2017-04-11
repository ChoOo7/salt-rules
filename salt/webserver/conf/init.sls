{% set apacheConfigAvDirectory = '/etc/apache2/conf-available/' %}
{% set apacheConfigEnDirectory = '/etc/apache2/conf-enabled/' %}

apache2conf:
  pkg.installed:
    - name : apache2
  service.running:
    - name: apache2
    - require:
      - pkg: apache2conf



/root/salt/apache2autorestart.shfromconf:
  file.managed:
    - name: /root/salt/apache2autorestart.sh
    - source: salt://webserver/files/apache2autorestart.sh
    - makedirs: True



{% for configName in ['mime-types.conf','custom-mime-types.conf','expireByType.conf','customHideFiles.conf','extendedStatus.conf','security_all_subdirs.conf', 'security.conf', 'follow_links.conf'] %}
{{ apacheConfigAvDirectory }}/{{ configName }}:
  file.managed:
    - source: salt://webserver/conf/files/{{ configName }}
    - require:
      - pkg: apache2conf

{{ apacheConfigEnDirectory }}/{{ configName }}:
  file.symlink:
    - target: {{ apacheConfigAvDirectory }}/{{ configName }}
{% endfor %}

/etc/apache2/envvars:
  file.managed:
      - source: salt://webserver/conf/files/envvars
      - require:
        - pkg: apache2conf
        
/etc/apache2/apache2.conf:
  file.managed:
      - source: salt://webserver/files/apache2.conf
      - require:
        - pkg: apache2conf

/etc/apache2/ports.conf:
  file.managed:
      - source: salt://webserver/files/ports.conf
      - require:
        - pkg: apache2conf

/srv/scripts/compress_all_apachelog.sh:
  file.managed:
    - source: salt://webserver/files/compress_all_apachelog.sh
    - makedirs: True

xinetd:
  pkg.installed: []
  service.running:
    - watch:
      - cmd: editxinetsservicesapachesprobe
      - file: /etc/xinetd.d/apacheprobe

touchConfigFile:
  cmd.run:
    - name: touch /srv/www-admin/.htpasswd
    - unless:  ls /srv/www-admin/.htpasswd

compress_all_apachelog_cron:
  cron.present:
    - identifier: compress_all_apachelog_cron
    - name: /srv/scripts/compress_all_apachelog.sh &> /srv/scripts/compress_all_apachelog.log
    - minute: 10
    - hour: 1


#Bien bien gourmand le nettoyage de session, et pas necessaire en + car nos sessions sont en memcached
/etc/cron.d/php5:
  file.absent:
    - name: /etc/cron.d/php5

/usr/bin/apacheprobe:
  file:
    - managed
    - source: salt://webserver/conf/files/apacheprobe.php
    - mode: 755

/srv/www-admin/html/apache2probe.php:
  file:
    - managed
    - makedirs: True
    - source: salt://webserver/conf/files/apacheprobe_web.php
    - mode: 755

/srv/www/_default_/html/apache2probe.php:
   file:
     - managed
     - source: salt://webserver/conf/files/apacheprobe_web.php
     - mode: 755

/etc/xinetd.d/apacheprobe:
  file:
    - managed
    - source: salt://webserver/conf/files/apacheprobe
    - mode: 755

editxinetsservicesapachesprobe:
  cmd.run:
    - name: echo 'apacheprobe        81/tcp              ' >> /etc/services
    - unless: if [ `cat /etc/services | grep ' 81/tcp' | wc -l` -eq 0 ]; then unexistantfunctiontohaveerror; fi;
