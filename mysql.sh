LOG_FILE=/tmp/mysql

source common.sh

echo "Setting Up MySQl Repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
StatusCheck $?

echo "Disable MySQl Default Module to Enable 5.7 MySQL"
dnf module disable mysql -y &>>$LOG_FILE
StatusCheck $?


echo "Install MySQl Service"
yum install mysql-community-server -y &>>$LOG_FILE
StatusCheck $?

echo "Start MySQl Service"
systemctl enable mysqld &>>$LOG_FILE
systemctl restart mysqld &>>$LOG_FILE
StatusCheck $?


DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${ROBOSHOP_MYSQL_PASSWORD}');
      FLUSH PRIVILEGES;" >/tmp/root-pass.sql

echo "show databases;" |mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}  &>>$LOG_FILE

if [ $? -ne 0 ]; then
  echo "Change the default root password"
  mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/root-pass.sql &>>$LOG_FILE
  StatusCheck $?
fi

echo 'show plugin' | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} 2>>/dev/null | grep validate_password &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo "Uninstall Password Validation Plugin"
  echo "uninstall plugin validate_password;" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>LOG_FILE
  StatusCheck $?
fi


echo "Downloading the Schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>LOG_FILE
StatusCheck $?


echo "Extract Schema"
cd /tmp
unzip -o mysql.zip &>>LOG_FILE
StatusCheck $?

echo "Load Schema"
cd mysql-main
mysql -u root -p${ROBOSHOP_MYSQL_PASSWORD} <shipping.sql &>>LOG_FILE
StatusCheck $?

