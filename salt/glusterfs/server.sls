
{% from "glusterfs/map.jinja" import server with context %}

glusterfs-server:
  # {% if grains['os'] == 'Ubuntu' %}
  #   pkgrepo.managed:
  #     - ppa: ppa:semiosis/ubuntu-glusterfs-3.4
  # {% endif %}
  pkg.installed: []
  service.running:
    - enable: True
#    - watch:
#      - file: /etc/haproxy/haproxy.cfg

# doc https://docs.saltstack.com/en/latest/ref/states/all/salt.states.glusterfs.html#salt.states.glusterfs.peered
# taken from https://github.com/salt-formulas/salt-formula-glusterfs/blob/master/glusterfs/server/setup.sls
# taken from https://github.com/salt-formulas/salt-formula-glusterfs/blob/master/glusterfs/server/service.sls

glusterfs_peers:
  glusterfs.peered:
    - names: {{ server.peers }}
    - require:
      - pkg: glusterfs-server

{%- for name, volume in server.volumes.iteritems() %}
{{ volume.storage }}:
  file.directory:
    - makedirs: true
  #  file.directory:
  #    - makedirs: true

glusterfs_format_{{name}}:
  blockdev.formatted:
    - name: {{volume.device}}

glusterfs_mount_{{name}}:
  mount.mounted:
    - name: {{volume.mountpoint}}
    - device: {{volume.device}}
    - fstype: ext4
    - mkmnt: True
    - persist: True
    - opts:
      - defaults,relatime
    - require:
      - blockdev: glusterfs_format_{{name}}

glusterfs_vol_{{name}}:
  glusterfs.volume_present:
    - name: {{name}}
    - replica: {{volume.replica }}
    - bricks: {{ volume.bricks }}
    - start: true
    - require:
      - glusterfs_format_{{name}}
      - glusterfs_mount_{{name}}
      - glusterfs: glusterfs_peers

glusterfs_vol_start_{{name}}:
  glusterfs.started:
    - name: {{ name }}
    - require:
      - glusterfs: glusterfs_vol_{{ name }}

{% endfor %}
