#!/usr/bin/python
import subprocess,os
import importlib
from os.path import expanduser
import argparse,getpass
import base64
def installSaltMinion(pwd,proxy=None):
  saltCallReturnCode=-1
  try: 
    saltCallReturnCode= subprocess.check_call(['salt-call','--version']);
  except OSError:
    pass

  if saltCallReturnCode == 0:
    print 'Salt is installed already' 
  else:
    print 'Install salt'
    
    downloadSaltbootstrapCommad=['curl', '-L', 'https://bootstrap.saltstack.com']
    installSaltCommad=['sh','install_salt.sh','-X']
    if not proxy is None:
      downloadSaltbootstrapCommad.extend('-x',proxy)
      installSaltCommad.extend(['-H',proxy])

    downloadSaltbootstrapCommad.extend(['-o', 'install_salt.sh'])
    subprocess.check_call(downloadSaltbootstrapCommad)
    installSaltCommad.extend(['stable'])
    subprocess.check_call(installSaltCommad)
    subprocess.check_call(['rm','install_salt.sh'])

def getArguments():
  parser=argparse.ArgumentParser()
  parser.add_argument('--proxy',
                    dest='proxy',
                    help='Proxy used to download all dependency. It will set http_proxy and https_proxy environment variable in salt process only') 
  parser.add_argument('--no-proxy',
                    action='store',
                    dest='noProxy',
                    help='It will set no_proxy environment variable in salt process only') 
  parser.add_argument('--dev',
                    action='store',
                    dest='dev',
                    default=False,
                    type=bool,
                    help='Install extra dependency useful during development.') 
  return parser.parse_args()

 
def prepareSaltClient(args):
  saltClient=importlib.import_module('salt.client')
  saltConfig=importlib.import_module('salt.config')
  opts = saltConfig.minion_config('./minion')
  opts['file_client'] = 'local'
  caller=saltClient.Caller(mopts=opts)
  if not args.proxy is None:
    print caller.function('environ.setval','http_proxy',proxy)
    print caller.function('environ.setval','https_proxy',proxy)
  if not args.noProxy is None:   
    print caller.function('environ.setval','no_proxy',noProxy)
  print 'sync states '+str(caller.function('saltutil.sync_all'))
  print 'install dulwich '+str(caller.function('pkg.install','python-dulwich'))
  return caller

def installDevEnv(caller):
  print caller.function('state.sls','vim.salt')

def getInstallationConf(caller):
  config={}
  config['hostname'] = raw_input("Enter hostname ({})  : ").format(caller.function('grains.item','fqdn'))
  config['smtp']={}
  config['smtp']['name']=raw_input("Enter smtp server name: ")
  config['smtp']['port']=raw_input("Enter smtp server port: ")
  config['smtp']['sender']=raw_input("Enter smtp server sender: ")
  config['smtp']['user']=raw_input("Enter smtp user : ")
  config['smtp']['password']=base64.b64encode(getpass.getpass("Enter smtp password: "))
  config['ldap']={}
  config['ldap']['name']=raw_input("Enter ldap server name: ")
  config['ldap']['port']=raw_input("Enter ldap server port: ")
  config['ldap']['user']=raw_input("Enter ldap user : ")
  config['ldap']['password']=base64.b64encode(getpass.getpass("Enter ldap password: "))
  print config
  return config

def installGitlab(caller,config):
  print caller.function('state.sls','gitlab',pillar=str(config))
  print 'Plase try login to gitlab on url: http://gitlab.{}\nLogin: root\nPassword: 5iveL!fe'.format(config['hostname'])
  print 'After that plase try login to gitlab-ci on url: http://ci.{0}\nAnd go to http://ci.{0}/admin/runners and copy register token'.format(config['hostname'])
  config['register_token']=raw_input("Enter gitlab ci token: ")

def installEnvrionment(caller,config):
  print caller.function('state.highstate',pillar=str(config))  

def main():
  if os.geteuid() != 0:
    exit('You need to have root privileges to run this script.\nPlease try again, this time using "sudo". Exiting.')
  pwd=os.path.dirname(os.path.realpath(__file__))
  args=getArguments()
  installSaltMinion(pwd,args.proxy)
  caller=prepareSaltClient(args)
  if args.dev:
    print caller.function('test.ping')
    installDevEnv(caller) 
  config=getInstallationConf(caller)
  installGitlab(caller,config)
  installEnvrionment(caller,config)
  print 'Installation was complated. Here are adresses to your development environment:\nGtilab:\t http://gitlab.{0}\nGitlab CI:\t http://ci{0}\nNexus Sonatype:\t http://nexus.{0}\nSonarQube:\t http://sonar.{0}'.format(config['hostname'])
if __name__ == '__main__':
  main()
