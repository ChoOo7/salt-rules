
glusterfs-server:
{% if grains['os'] == 'Ubuntu' %}
  pkgrepo.managed:
    - ppa: ppa:semiosis/ubuntu-glusterfs-3.4
{% endif %}
  pkg.installed: []
  service.running:
    - enable: True
#    - watch:
#      - file: /etc/haproxy/haproxy.cfg

# doc https://docs.saltstack.com/en/latest/ref/states/all/salt.states.glusterfs.html#salt.states.glusterfs.peered
# taken from https://github.com/salt-formulas/salt-formula-glusterfs/blob/master/glusterfs/server/setup.sls
# taken from https://github.com/salt-formulas/salt-formula-glusterfs/blob/master/glusterfs/server/service.sls

glusterf_peers:
  glusterfs.peered:
    - names: {{ server.peers }}
    - require:
      - pkg: glusterfs-server

{%- for name, volume in server.volumes.iteritems() %}
{{ volume.storage }}:
  file.directory:
    - makedirs: true

glusterfs_vol_{{name}}:
  glusterfs.volume_present:
    - name: {{name}}
    - replica: {{volume.replica }}
    - bricks: {{ volume.bricks }}
    - start: true
    - require: glusterfs_peers

glusterfs_vol_start_{{name}}:
  glusterfs.started:
    - name: {{ volume }}
    - require:
    - glusterfs: glusterfs_vol_{{ name }}
{% endfor %}
