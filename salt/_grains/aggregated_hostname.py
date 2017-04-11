#!/usr/bin/env python


### AUTO MANAGED BY SALT. DO NOT EDIT ###

import socket
import re

def aggregated_hostname():
     # initialize a grains dictionary
     grains = {}
     # Some code for logic that sets grains like
     compacted_hostname = socket.gethostname();
     
     compacted_hostname = compacted_hostname.replace('-front1', '');
     compacted_hostname = compacted_hostname.replace('-salt1', '');
     compacted_hostname = compacted_hostname.replace('-front2', '');
     compacted_hostname = compacted_hostname.replace('-front3', '');
     compacted_hostname = compacted_hostname.replace('-front4', '');
     compacted_hostname = compacted_hostname.replace('-front5', '');
     compacted_hostname = compacted_hostname.replace('-node1', '');
     compacted_hostname = compacted_hostname.replace('-node2', '');
     compacted_hostname = compacted_hostname.replace('-node3', '');
     compacted_hostname = compacted_hostname.replace('-node4', '');
     compacted_hostname = compacted_hostname.replace('-node5', '');
     compacted_hostname = compacted_hostname.replace('-worker1', '');
     compacted_hostname = compacted_hostname.replace('-worker2', '');
     compacted_hostname = compacted_hostname.replace('-worker3', '');
     compacted_hostname = compacted_hostname.replace('-data1', '');
     compacted_hostname = compacted_hostname.replace('-data2', '');
     compacted_hostname = compacted_hostname.replace('-data3', '');
     compacted_hostname = compacted_hostname.replace('1', '');
     compacted_hostname = compacted_hostname.replace('2', '');
     compacted_hostname = compacted_hostname.replace('3', '');

     hosttype='other';
     initialHostname = socket.gethostname();
     if('-front' in initialHostname):
       hosttype='front';
     if('-node' in initialHostname):
       hosttype='node';
     if('-salt' in initialHostname):
       hosttype='node';
     if('-worker' in initialHostname):
       hosttype='worker';
     if('-data' in initialHostname):
       hosttype='data';


     compacted_hostname_before_replace = compacted_hostname;
       
     thehostname = socket.gethostname();  
     
     isPreprod = 'preprod' in socket.gethostname() or 'noprod' in socket.gethostname();

     is_node_master = ('1' in initialHostname) or ('1' in thehostname);

     hostIndex = socket.gethostname();
     hostIndex = hostIndex.replace(compacted_hostname_before_replace, '');
     hostIndex = hostIndex.replace(hosttype, '');
     hostIndex = hostIndex.replace('-', '');

     
     grains['aggregated_hostname'] = compacted_hostname + '.' + thehostname
     grains['base_hostname'] = compacted_hostname
     grains['hosttype'] = hosttype
     grains['ispreprod'] = isPreprod
     grains['hostindex'] = hostIndex
     
     grains['nodename'] = compacted_hostname
     grains['node_master'] = compacted_hostname+'1'

     grains['is_node_master'] = is_node_master
     return grains
