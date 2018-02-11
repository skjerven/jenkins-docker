FROM nginx:latest

MAINTAINER Brian Skjerven

# Add nginx config files
COPY conf/jenkins.conf /etc/nginx/conf.d/jenkins.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Open port 80 for nginx
EXPOSE 80

CMD ["nginx"]
