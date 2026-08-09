sudo nano /etc/nginx/sites-available/go-braminnovation

sudo ln -s /etc/nginx/sites-available/go-braminnovation /etc/nginx/sites-enabled/

sudo nginx -t

sudo systemctl restart nginx
