COMPONENT=dispatch

LOG_FILE=/tmp/${COMPONENT}

source common.sh


echo "Installing Golang"
yum install golang -y &>>${LOG_FILE}
StatusCheck $?

APP_PREREQ

cd /${COMPONENT}

go mod init dispatch
go get
go build