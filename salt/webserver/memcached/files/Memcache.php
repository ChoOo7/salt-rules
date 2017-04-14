<?php
return array (
  'stats_api' => 'Server',
  'slabs_api' => 'Server',
  'items_api' => 'Server',
  'get_api' => 'Server',
  'set_api' => 'Server',
  'delete_api' => 'Server',
  'flush_all_api' => 'Server',
  'connection_timeout' => '1',
  'max_item_dump' => '100',
  'refresh_rate' => 5,
  'memory_alert' => '80',
  'hit_rate_alert' => '90',
  'eviction_alert' => '0',
  'file_path' => 'Temp/',
  'servers' =>
  array (
    'Default' =>
    array (
     'host 1' =>
      array (
        'hostname' => '{{ grains['base_hostname']  }}-{{ pillar['hostname-shortname'] }}1',
        'port' => '11211',
      ),
      'host 2' =>
      array (
        'hostname' => '{{ grains['base_hostname']  }}-{{ pillar['hostname-shortname'] }}2',
        'port' => '11211',
      ),
      'host 3' =>
      array (
        'hostname' => '{{ grains['base_hostname']  }}-{{ pillar['hostname-shortname'] }}3',
        'port' => '11211',
      ),
    ),
  ),
);
