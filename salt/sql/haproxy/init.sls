{% if grains['os'] == 'Debian' %}
python-apt:
  pkg:
    - installed    
  cmd.run:
    - name: echo deb http://httpredir.debian.org/debian wheezy-backports main > /etc/apt/sources.list.d/backports.list
    - unless: ls /etc/apt/sources.list.d/backports.list
{% endif %}

haproxy:
{% if grains['os'] == 'Ubuntu' %}
  pkgrepo.managed:
    - ppa: vbernat/haproxy-1.5
{% endif %}
  pkg.installed: []
  service.running:
    - enable: True
    - watch:
      - file: /etc/haproxy/haproxy.cfg
    #- require:
    #  - pkg: apache2

#xinetd:
#  pkg.installed: []
#  service.running:
#    - watch:
#      - cmd: editxinetsservices
#      - file: /etc/xinetd.d/mysqlchk

/etc/haproxy/haproxy.cfg:
  file:
    - managed
    - source: salt://sql/haproxy/files/haproxy.cfg
    - template: jinja

/etc/default/haproxy:
  file:
    - managed
    - source: salt://sql/haproxy/files/default-haproxy

/usr/bin/clustercheck:
  file:
    - managed
    - source: salt://sql/haproxy/files/clustercheck.sh
    - mode: 755
    - template: jinja

/etc/xinetd.d/mysqlchk:
  file:
    - managed
    - source: salt://sql/haproxy/files/mysqlchk
    - mode: 755

/usr/bin/hatop:
  file:
    - managed
    - source: salt://sql/haproxy/files/hatop
    - mode: 755


editxinetsservices:
  cmd.run:
    - name: echo 'mysqlchk        9207/tcp              ' >> /etc/services
    - unless: if [ `cat /etc/services | grep '9207' | wc -l` -eq 0 ]; then unexistantfunctiontohaveerror; fi;


