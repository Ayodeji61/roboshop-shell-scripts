LOG_FILE=/tmp/redis

source common.sh

echo "Setup YUM Repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG_FILE}
StatusCheck $?

echo "Enabling the Redis YUM Module"
dnf module enable redis:remi-6.2 -y &>>${LOG_FILE}
StatusCheck $?

echo "Installing Redis"
yum install redis -y &>>${LOG_FILE}
StatusCheck $?

 echo "Update the Redis Listening IP from 127.0.0.1 to 0.0.0.0"
 sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${LOG_FILE}
 StatusCheck $?

 echo "Starting the Redis Service Application"
 systemctl enable redis &>>${LOG_FILE}
 systemctl start redis &>>${LOG_FILE}
 StatusCheck $?