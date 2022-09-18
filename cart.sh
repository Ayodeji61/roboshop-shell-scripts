LOG_FILE=/tmp/cart

source common.sh

echo "Setting up NODEJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
StatusCheck $?

echo "Installing NODEJS"
yum install nodejs -y &>>${LOG_FILE}
StatusCheck $?

id roboshop
if [ $? -ne 0 ]; then
    echo "Adding Application User Roboshop"
    useradd roboshop &>>${LOG_FILE}
    StatusCheck $?
fi


echo "Downloading the Cart Application Data"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /home/roboshop

echo "Extracting the Cart Application Data"
unzip /tmp/cart.zip &>>${LOG_FILE}
StatusCheck $?

mv cart-main cart &>>${LOG_FILE}
cd cart

echo "Installing NODEJS Dependencies"
npm install &>>${LOG_FILE}
StatusCheck $?

echo "Settinig up Cart Service"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>${LOG_FILE}
StatusCheck $?

echo "Starting the Cart Service"
systemctl daemon-reload &>>${LOG_FILE}
systemctl enable cart &>>${LOG_FILE}
systemctl start cart &>>${LOG_FILE}
StatusCheck $?