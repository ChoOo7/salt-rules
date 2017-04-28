
glusterfs:
  server:
    peers:
    - arengi-back1
    - arengi-back2
    - arengi-back3
    volumes:
       glance:
         storage: /data
         replica: 3
         bricks:
         - arenggi-back1:/data
         - arenggi-back2:/data
         - arenggi-back3:/data
    enabled: true
