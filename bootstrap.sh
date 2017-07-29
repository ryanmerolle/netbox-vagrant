#!/usr/bin/env bash

# Prevent
export DEBIAN_FRONTEND=noninteractive

# Install Git
printf "Step 1 of 20: Installing git & cloning netbox-vagrant...\n"
apt-get install git -y -qq > /dev/null
cd /tmp/ && git clone -b master https://github.com/ryanmerolle/netbox-vagrant.git

# Update Ubuntu
printf "Step 2 of 20: Updating Ubuntu...\n"
apt-get update -y -qq > /dev/null

# Install Postgres & start service
printf "Step 3 of 20: Installing & starting Postgres...\n"
apt-get install postgresql libpq-dev -y -qq > /dev/null
sudo service postgresql start

# Setup Postgres with netbox user, database, and permissions
printf "Step 4 of 20: Setup Postgres with netbox user, database, & permissions."
sudo -u postgres psql -c "CREATE DATABASE netbox"
sudo -u postgres psql -c "CREATE USER netbox WITH PASSWORD 'J5brHrAXFLQSif0K'"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE netbox TO netbox"

# Install nginx
printf "Step 5 of 20: Installing nginx...\n"
apt-get install nginx -y -qqm> /dev/null

# Install Python 2
printf "Step 6 of 20: Installing Python 3 dependencies...\n"
apt-get install python3 python3-dev python3-pip libxml2-dev libxslt1-dev libffi-dev graphviz libpq-dev libssl-dev -y -qq > /dev/null

# Upgrade pip
printf "Step 7 of 20: Upgrade pip\n"
pip3 install --upgrade pip

# Install gunicorn & supervisor
printf "Step 8 of 20: Installing gunicorn & supervisor...\n"
pip3 install gunicorn
apt-get install supervisor -y -qq > /dev/null

printf "Step 9 of 20: Cloning NetBox repo...\n"
# Create netbox base directory & navigate to it
mkdir -p /opt/netbox/ && cd /opt/netbox/
# git clone netbox master branch
git clone -b master https://github.com/digitalocean/netbox.git .

# Install NetBox requirements
printf "Step 10 of 20: Installing NetBox requirements...\n"
# pip install -r requirements.txt
pip3 install -r requirements.txt

# Use configuration.example.py to create configuration.py
printf "Step 11 of 20: Configuring Netbox...\n"
cp /opt/netbox/netbox/netbox/configuration.example.py /opt/netbox/netbox/netbox/configuration.py
# Update configuration.py with database user, database password, netbox generated SECRET_KEY, & Allowed Hosts
sed -i "s/'USER': '',  /'USER': 'netbox',  /g" /opt/netbox/netbox/netbox/configuration.py
sed -i "s/'PASSWORD': '',  /'PASSWORD': 'J5brHrAXFLQSif0K',  /g" /opt/netbox/netbox/netbox/configuration.py
sed -i "s/ALLOWED_HOSTS \= \[\]/ALLOWED_HOSTS \= \['netbox.internal.local', 'netbox.localhost', 'localhost', '127.0.0.1'\]/g" /opt/netbox/netbox/netbox/configuration.py
SECRET_KEY=$( python3 /opt/netbox/netbox/generate_secret_key.py )
sed -i "s~SECRET_KEY = ''~SECRET_KEY = '$SECRET_KEY'~g" /opt/netbox/netbox/netbox/configuration.py
# Clear SECRET_KEY variable
unset SECRET_KEY

# Setup apache, gunicorn, & supervisord config using premade examples (need to change netbox-setup)
printf "Step 12 of 20: Configuring nginx...\n"
cp /tmp/netbox-vagrant/config_files/nginx-netbox.example /etc/nginx/sites-available/netbox
printf "Step 13 of 20: Configuring gunicorn...\n"
cp /tmp/netbox-vagrant/config_files/gunicorn_config.example.py /opt/netbox/gunicorn_config.py
printf "Step 14 of 20: Configuring supervisor...\n"
cp /tmp/netbox-vagrant/config_files/supervisord-netbox.example.conf /etc/supervisor/conf.d/netbox.conf

# Apache Setup (enable the proxy and proxy_http modules, and reload Apache)
printf "Step 15 of 20: Completing web service setup...\n"
cd /etc/nginx/sites-enabled/
rm default
ln -s /etc/nginx/sites-available/netbox
service nginx restart
service supervisor restart

# Install the database schema
printf "Step 16 of 20: Install the database schema...\n"
python3 /opt/netbox/netbox/manage.py migrate

# Create admin / admin superuser
printf "Step 17 of 20: Create NetBox superuser...\n"
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | python3 /opt/netbox/netbox/manage.py shell --plain

# Collect Static Files
printf "Step 18 of 20: collectstatic\n"
python3 /opt/netbox/netbox/manage.py collectstatic --no-input <<<yes

# Load Initial Data (Optional) Comment out if you like
printf "Step 19 of 20: Load intial data.\n"
python3 /opt/netbox/netbox/manage.py loaddata initial_data

# Cleanup netbox-vagrant setup
printf "Step 20 of 20: Cleaning up netbox-vagrant setup files...\n"
rm -rf /tmp/netbox-vagrant/
printf "netbox-vagrant setup files deleted...\n"

# Status Complete
printf "%s\nCOMPLETE: NetBox-Demo Provisioning COMPLETE!!\n"
printf "%s\nTo login to the Vagrant VM use vagrant ssh in the current directory\n"
printf "%s\nTo login to the Netbox-Demo web portal go to http://netbox.localhost:8080\n"
printf "%s\nWeb portal superuser credentials are admin / admin\n"