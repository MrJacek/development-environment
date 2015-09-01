postgres:
   users:
     sonarqube:
       password: 'sonarqube'
       createdb: False
       createroles: False
       createuser: False
       inherit: True
       replication: False
   acls:
     - ['local', 'sonarqube', 'sonarqube']
   databases:
     sonarqube:
       owner: 'sonarqube'
       user: 'sonarqube'
       template: 'template0'
       lc_ctype: 'en_US.UTF-8'
       lc_collate: 'en_US.UTF-8'
