# beware device will be formatted
glusterfs:
  server:
    peers:
    - arengi-back1
    - arengi-back2
    - arengi-back3
    volumes:
       data:
         storage: /data/gluster
         mountpoint: /data
         device: /dev/sdb
         replica: 3
         bricks:
         - arengi-back1:/data/gluster
         - arengi-back2:/data/gluster
         - arengi-back3:/data/gluster
    enabled: true
  client:
    volumes:
      data:
        path: /mnt/gluster
        server: arengi-back1
        user: www-data
        group: www-data
    enabled: true
