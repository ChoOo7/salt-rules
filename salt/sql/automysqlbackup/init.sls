{%- if grains['is_node_master'] %}
/srv/mysql_backup:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/srv/mysql_backup/automysqlbackup_2.5.sh:
  file.managed:
    - source: salt://sql/automysqlbackup/files/automysqlbackup_2.5.sh
    - group: root
    - makedirs: True
    - mode: 750
    - template: jinja

automysqlbackup_2.5.sh:
  cron.present:
    - identifier: Sauvegarde des bases de donnees
    - user: root
    - name: /srv/mysql_backup/automysqlbackup_2.5.sh > /srv/mysql_backup/mysql_backup.log
    - hour: 0
    - minute: 10

{% endif %}

