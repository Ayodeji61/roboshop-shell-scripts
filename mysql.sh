LOG_FILE=/tmp/mysql

source common.sh

echo "Settiun Up MySQl Repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
StatusCheck $?

echo "Disable MySQl Default Module to Enable 5.7 MySQL"
dnf module disable mysql -y &>>$LOG_FILE
$StatusCheck $?


echo "Start MySQl Service"
yum install mysql-community-server -y &>>$LOG_FILE
StatusCheck $?

echo "Start MySQl Service"
systemctl enable mysqld &>>$LOG_FILE
systemctl restart mysqld &>>$LOG_FILE
StatusCheck $?


# grep temp /var/log/mysqld.log

# mysql_secure_installation

# mysql_secure_installation

# > uninstall plugin validate_password;


# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"

# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql
