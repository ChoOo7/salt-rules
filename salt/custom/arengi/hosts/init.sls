
addBack1:
 cmd.run:  
   - name: echo "10.0.0.2 arengi-back1" >> /etc/hosts
   - unless: if [ `cat /etc/hosts | grep '10.0.0.2 areng' | wc -l` -eq 0 ]; then unexistantfunctiontohaveerror; fi;

addBack2:
 cmd.run:  
   - name: echo "10.0.0.3 arengi-back2" >> /etc/hosts
   - unless: if [ `cat /etc/hosts | grep '10.0.0.3 areng' | wc -l` -eq 0 ]; then unexistantfunctiontohaveerror; fi;

addBack3:
 cmd.run:  
   - name: echo "10.0.0.4 arengi-back3" >> /etc/hosts
   - unless: if [ `cat /etc/hosts | grep '10.0.0.4 areng' | wc -l` -eq 0 ]; then unexistantfunctiontohaveerror; fi;
   
