LOG_FILE=/tmp/frontend1

echo "Installing Nginx"
yum install ngin -y &>>$LOG_FILE
if [ $? -eq 0 ]; then
  echo STATUS = "SUCCESS"
  else
    echo STATUS = "FAILURE"
    exit 1
fi


echo "Enable Nginx"
systemctl enable nginx &>>$LOG_FILE
systemctl start nginx &>>$LOG_FILE

echo "Download Application Code"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}


cd /usr/share/nginx/html

echo "Remove Old Content"
rm -rf * &>>$LOG_FILE

echo "Extracting Application Code File"
unzip /tmp/frontend.zip &>>$LOG_FILE

mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE


systemctl restart nginx &>>$LOG_FILE
