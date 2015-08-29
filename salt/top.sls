base:
  'centos7':
     - vim.salt
     - dns
     - sun-java
     - sun-java.env
     - docker
     - maven
     - maven.env
     - gitlab
     - gitlab.runner
     - gocd
     - gocd.nginx
     - nexus
     - nexus.nginx
