
echo "Install HTTPD"
yum install httpd -y

echo "Start httpd service"
systemctl start httpd
systemctl enable httpd

echo "Install mysql"
dnf install mysql-server -y

systemctl start mysqld
systemctl enable mysqld

