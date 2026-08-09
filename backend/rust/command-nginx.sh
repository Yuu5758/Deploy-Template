sudo nano /etc/nginx/sites-available/rust-api

sudo ln -s /etc/nginx/sites-available/rust-api /etc/nginx/sites-enabled/

sudo nginx -t

sudo systemctl restart nginx
