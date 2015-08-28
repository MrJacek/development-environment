#!/usr/bin/python
import subprocess
import os,time
FNULL = open(os.devnull, 'w')
subprocess.check_output(['curl','-L', 'https://bootstrap.saltstack.com', '-o', 'install_salt.sh'])
salt=subprocess.Popen(['/bin/sh','install_salt.sh', '-X','stable'],stdout=FNULL, stderr=subprocess.STDOUT,close_fds=True)
#salt=subprocess.Popen(['/bin/sh','install_salt.sh', '-X','stable'])

while salt.returncode != 0:
  pool=salt.poll
  print pool
  time.sleep(5)
  print 'returncode: {}'.format(salt.returncode)
    #hostname=raw_input('Enter host name: ')
  # print 'Your hostname is: {}'.format(hostname)
#import salt.client


#caller = salt.client.Caller()
#caller.function('saltutil.sync_all')
#result=caller.function('state.highstate')
#print result

# Check if salt is already installed.
#salt-call --version

#if [ "$?" -ne "0" ]; then
# Download bootstrap script to install salt.
#curl -L https://bootstrap.saltstack.com -o install_salt.sh
# Install salt-minion wihout staring deamon.
#sh install_salt.sh -X -H http://squid.mcx.local:8080 stable
# Remove bootstrap script.
#rm install_salt.sh
# Append config for salt minion to switch masterless mode.

