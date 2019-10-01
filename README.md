# Zabbix-autoclose-events

Sometimes You need to automaticaly close problem, which cannot be closed by trigger expression. For example promlems based on Eventlog events - You want to receive notification, but You dont want to close these events manualy. 

This problem is typically with triggers based on change funcion, which is not evaluated by timer process.

You Can use simple script executed by action or escalation. 

Setup:
1. Copy ack_event.pl to /etc/zabbix/scripts/
2. copy ZabbixAPI.pm to /etc/zabbix/scripts/api/
3. change rights: chown zabbix  /etc/zabbix/scripts/ack_event.pl
                  chown zabbix  /etc/zabbix/scripts/api/ZabbixAPI.pm
                  chmod +x /etc/zabbix/scripts/ack_event.pl
   or use your own paths
4. Fill in server address, username and password in script
5. Configure trigger to support event acknowledgements and close
6. create user withrights to close events.
7. Create Operation in Action which runs script vith macro {EVENT.ID} as parameter:
   /etc/scripts/ack_event.pl {EVENT.ID}
8. test it

Script is based on ZabbixAPI.pm module from https://github.com/v-zhuravlev/ZabbixAPI

