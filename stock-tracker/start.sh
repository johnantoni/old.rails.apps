cd /var/www/apps/red91/tmp/pids
rm *.pid
cd /var/www/apps/red91
rake log:clear
thin restart --port 8000 --environment production --servers 1

cd /var/www/apps/atompad/tmp/pids
rm *.pid
cd /var/www/apps/atompad
rake log:clear
thin restart --port 8100 --environment production --servers 1

cd /var/www/apps/stock/tmp/pids
rm *.pid
cd /var/www/apps/stock
rake log:clear
thin restart --port 8200 --environment production --servers 1
