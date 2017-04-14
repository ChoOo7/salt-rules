base:
  '*':                                                                                                                                                                    
    - php7
    - galera
    - hostname-front
    
  'salt1':                                                                                                                                                                    
    - php56
  'arengibox-front*':                                                                                                                                                                    
    - php56
    - galera-arengibox
    
  'arengibox-back*':                                                                                                                                                                    
    - php56
    - galera-arengibox
    - hostname-back