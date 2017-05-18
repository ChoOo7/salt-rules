
{% from "glusterfs/map.jinja" import client with context %}

glusterfs_client_packages:
  pkg.installed:
    - names:
      - glusterfs-client
      - attr

{%- if client.volumes is defined %}
{%- for name, volume in client.volumes.iteritems() %}


{%- set path_escaped = salt['cmd.run']('systemd-escape -p --suffix=mount '+volume.path)  %}

/etc/systemd/system/{{ path_escaped }}:
  file.absent


glusterfs_mount_{{ name }}:
  mount.mounted:
    - name: {{ volume.path }}
    - device: {{ volume.server }}:/{{ name }}
    - fstype: glusterfs
    - mkmnt: true
    - opts: 'defaults'
    - require:
      - pkg: glusterfs_client_packages

{# Fix privileges on mount #}
#{%- if volume.user is defined or volume.group is defined %}
#
#glusterfs_dir_{{ name }}:
#  file.directory:
#    - name: {{ volume.path }}
#    - user: {{ volume.get('user', 'root') }}
#    - group: {{ volume.get('group', 'root') }}
#    - mode: {{ volume.get('mode', '755') }}
#    - require:
#      - mount: glusterfs_mount_{{ name }}
#
#{%- endif %}

{%- endfor %}
{%- endif %}
