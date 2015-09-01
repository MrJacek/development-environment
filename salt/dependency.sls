python-dulwich:
  pkg.installed: []

postgresql-server:
  pkg.installed: []
postgres:
  user.present: []

java-home:
  file.append:
    - name: /etc/environment
    - text:
      - export JAVA_HOME=/usr/lib/java
      - export PATH=$JAVA_HOME/bin:$PATH
