source /home/vagrant/.sandbox.conf.sh

echo "Installing Datadog Agent 7 from api_key: ${DD_API_KEY} but not starting it..."
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=${DD_API_KEY} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

sudo yum -y update
sudo yum -y install httpd
sudo yum -y install php

sudo systemctl start httpd.service
sudo systemctl enable httpd.service

sudo chown vagrant.vagrant /var/www/html/

echo '<?php
    date_default_timezone_set('UTC');
    phpinfo();
?>'| sudo tee -a /var/www/html/index.php

sudo yum -y install wget

wget https://github.com/DataDog/dd-trace-php/releases/download/0.54.0/datadog-php-tracer-0.54.0-1.x86_64.rpm

sudo rpm -ivh datadog-php-tracer-0.54.0-1.x86_64.rpm

sudo systemctl restart httpd.service
