LOG_FILE=/tmp/mongodb1

source code.sh

echo "Setup Mongo Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo  &>>$LOG_FILE
StatusCheck $?

echo "Install Mongodb"
yum install -y mongodb-org &>>$LOG_FILE
StatusCheck $?

echo "Start and Enabling Mongo Services"
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
StatusCheck $?

echo "Update configuration file from 127.0.0.1 to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
StatusCheck $?

echo "Restart Services"
systemctl restart mongod &>>$LOG_FILE
StatusCheck $?

echo "Download Appllication file"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /tmp
echo "Extract Application file"
unzip mongodb.zip &>>$LOG_FILE
StatusCheck $?

cd mongodb-main

echo "Load Catalogue Schema"
mongo < catalogue.js &>>$LOG_FILE
StatusCheck $?

echo "Load User Schema"
mongo < users.js &>>$LOG_FILE
StatusCheck $?
