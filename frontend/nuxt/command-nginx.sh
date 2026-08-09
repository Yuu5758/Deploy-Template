sudo nano /etc/nginx/sites-available/braminnovation

sudo ln -s /etc/nginx/sites-available/braminnovation /etc/nginx/sites-enabled/

sudo nginx -t

sudo systemctl restart nginx
