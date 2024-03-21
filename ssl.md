## Install The Docker
```
sudo yum install docker -y
```
## Starting The Docker
```
sudo systemctl start docker
```
## Enabling The Docker
```
sudo systemctl enable docker
```
## Add The Current User To the Docker Group
```
sudo usermod -a -G docker $(whoami)
```
## Install the Apache
```
sudo dnf update -y
sudo dnf list | grep httpd
sudo dnf install -y httpd.x86_64
sudo systemctl start httpd.service
sudo systemctl status httpd.service
sudo systemctl enable httpd.service
```
## Update Server 80 and Add the Domain name in /etc/httpd/conf.httpd.conf
```
<VirtualHost *:80>
    ServerName beta.demo.com

    <Location />
        ProxyPass http://localhost:3000/
        ProxyPassReverse http://localhost:3000/

        ProxyPreserveHost On
        ProxyAddHeaders On

        RequestHeader set X-Forwarded-Proto "http"
    </Location>
RewriteEngine on
RewriteCond %{SERVER_NAME} =beta.nyinst.com
RewriteRule $ https://beta.nyinst.com/ [R=301,L]
</VirtualHost>
<VirtualHost *:80>
    ServerName 192.46.20.188
    Redirect permanent / https://beta.demo.com/
</VirtualHost>
```

##  Install the CertBot
```
sudo yum install certbot
sudo yum install python-certbot-apache
```

## Create SSl Certificate
```
sudo certbot --apache -d example.com -d www.example.com
```

### Automatically Renew Let’s Encrypt Certificates
```
crontab -e
```
```
0 12 * * * /usr/bin/certbot renew --quiet
```

### Uninstall Apache
```
sudo yum erase httpd httpd-tools apr apr-util
```
