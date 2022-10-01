LOG_FILE=/tmp/frontend

yum install nginx -y &>>${LOG_FILE}
systemctl enable nginx &>>${LOG_FILE}
systemctl start nginx &>>${LOG_FILE}


curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}


cd /usr/share/nginx/html
rm -rf * &>>${LOG_FILE}
unzip /tmp/frontend.zip &>>${LOG_FILE}
mv frontend-main/static/* . &>>${LOG_FILE}
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}


systemctl restart nginx &>>${LOG_FILE}
