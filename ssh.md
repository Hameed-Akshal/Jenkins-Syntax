### Install the Apache
```
sudo dnf update -y
sudo dnf list | grep httpd
sudo dnf install -y httpd.x86_64
sudo systemctl start httpd.service
sudo systemctl status httpd.service
sudo systemctl enable httpd.service
```
### Check The configuration syntax
```
sudo apachectl configtest
```
### Update Server 80 and Add the Domain name in /etc/httpd/conf.httpd.conf
```
<VirtualHost *:80>
    ServerName beta.demo.com

    <Location />
        ProxyPass http://localhost:3000/
        ProxyPassReverse http://localhost:3000/
        #AllowEncodedSlashes NoDecode

        ProxyPreserveHost On
        #ProxyVia Full
        ProxyAddHeaders On

        RequestHeader set X-Forwarded-Proto "http"
    </Location>
RewriteEngine on
RewriteCond %{HTTP_HOST} ^52\.66\.200\.188$ [NC]
RewriteCond %{SERVER_NAME} =beta.nyinst.com
RewriteRule $ https://beta.nyinst.com/ [R=301,L]
Redirect permanent / https://beta.nyinst.com/
</VirtualHost>
```

###  Install the CertBot
```
sudo yum install certbot
sudo yum install python-certbot-apache
```

### Create SSl Certificate
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
