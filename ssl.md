### Install the Nginx
```
sudo yum install nginx
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
sudo systemctl status nginx.service
```

### Comment the Root Location , below code under server 80 and add the domain name 
```
location / {
        proxy_pass http://localhost:8080;  # Change the port if your jenkins  is running on a dif
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        }
```

### Check The Configuration Syntax & Restart The Nginx
```
  nginx -t && nginx -s reload
```

###  Install the CertBot
```
sudo yum install certbot
sudo yum install python-certbot-nginx
```

### Create SSl Certificate
```
sudo certbot --nginx -d example.com -d www.example.com
```

### Automatically Renew Let’s Encrypt Certificates
```
crontab -e
```
```
0 12 * * * /usr/bin/certbot renew --quiet
```
