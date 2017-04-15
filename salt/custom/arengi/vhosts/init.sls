

{% for configName in ['002-preprod.conf'] %}

/etc/apache2/sites-available/{{ configName }}:
  file.managed:
    - source: salt://custom/arengi/vhosts/files/{{ configName }}
    - group: root
    - mode: 750
    - template: jinja
    
/etc/apache2/sites-enabled/{{ configName }}:
  file.symlink:
      - target: ../sites-available/{{ configName }}
    

{% endfor %}

reloadApache2:
 cmd.run:  
   - name: service apache2 reload
