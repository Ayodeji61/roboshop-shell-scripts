COMPONENT=dispatch

LOG_FILE=/tmp/${COMPONENT}

source common.sh


echo "Installing Golang"
yum install golang -y &>>${LOG_FILE}
StatusCheck $?

APP_PREREQ


echo "Go into Initial Dispatch"
go mod init dispatch &>>${LOG_FILE}
StatusCheck $?

echo "Go Get"
go get &>>${LOG_FILE}
StatusCheck $?

echo "Build"
go build &>>${LOG_FILE}
StatusCheck $?

SYSTEMD_SETUP