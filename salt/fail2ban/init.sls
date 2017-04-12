fail2ban:
  pkg.installed: 
     - name: fail2ban
/etc/fail2ban/jail.conf:
 file:
   - managed  
   - source: salt://fail2ban/files/jail.conf
/etc/fail2ban/jail.d/sshd.conf:
 file:
   - managed  
   - source: salt://fail2ban/files/sshd.conf

