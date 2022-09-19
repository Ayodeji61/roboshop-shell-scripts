COMPONENT=dispatch

LOG_FILE=/tmp/${COMPONENT}

source common.sh


echo "Installing Golang"
yum install golang -y &>>${LOG_FILE}
StatusCheck $?

APP_PREREQ

cd /${COMPONENT}

go mod init dispatch &>>${LOG_FILE}
StatusCheck $?

go get &>>${LOG_FILE}
StatusCheck $?

go build &>>${LOG_FILE}
StatusCheck $?