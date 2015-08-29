{% set p  = salt['pillar.get']('gocd', {}) %}
{% set pc = p.get('config', {}) %}
{% set g  = salt['grains.get']('gocd', {}) %}
{% set gc = g.get('config', {}) %}

{%- set server_port      = gc.get('port', pc.get('port', '8153')) %}
{%- set agent_port      = gc.get('port', pc.get('port', '8154')) %}
{%- set server_name = gc.get('server_name', pc.get('server_name', grains.get('fqdn'))) %}

{%- set gocd = {} %}
{%- do gocd.update( {
                          'agent_port'     : agent_port,
                          'server_port'    : server_port,
                          'server_name'    : server_name,
                     }) %}
