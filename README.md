# handler-mattermost

## Install 

Copy .json files to /etc/sensu/conf.d/ 

Copy .rb file to /etc/sensu/plugins/

restart sensu server

## Testing

While testing rather then triggering real alerts you can test if its working by pipeing test-event.json into the standard in of handler-mattermost.json


cat test-event.json | ./handler-mattermost.json
