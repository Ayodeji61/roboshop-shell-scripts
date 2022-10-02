
echo "Install HTTPD"
yum install httpd -y

echo "Start httpd service"
systemctl start httpd
systemctl enable httpd

echo "Setting Up MySQl Repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo

echo "Disable MySQl Default Module to Enable 5.7 MySQL"
dnf module disable mysql -y



echo "Install MySQl Service"
yum install mysql-community-server -y


echo "Start MySQl Service"
systemctl enable mysqld
systemctl restart mysqld


DEFAULT_PASSWORD=$(grep 'empty password' /var/log/mysql/mysqld.log | awk '{print $NF}')

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${LAMP_MYSQL_PASSWORD}');
      FLUSH PRIVILEGES;" >/tmp/root-pass.sql

echo "show databases;" | mysql -uroot -p${LAMP_MYSQL_PASSWORD}

if [ $? -ne 0 ]; then
  echo "Change the default root password"
  mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/root-pass.sql

fi

echo 'show plugin' | mysql -uroot -p${LAMP_MYSQL_PASSWORD} 2>>/dev/null | grep validate_password
if [ $? -eq 0 ]; then
  echo "Uninstall Password Validation Plugin"
  echo "uninstall plugin validate_password;" | mysql -uroot -p${LAMP_MYSQL_PASSWORD}

fi