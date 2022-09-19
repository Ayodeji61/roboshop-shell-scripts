ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should run this script as root user or with sudo priviledges.
  exit 1
fi

StatusCheck() {
  if [ $1 -eq 0 ]; then
    echo -e Status = "\e[32mSUCCESS\e[0m"
  else
    echo -e Status = "\e[31mFAILURE\e[0m"
    exit 1
    fi
}

SYSTEMD_SETUP() {
  echo "Update SystemD Service File"
    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
    StatusCheck $?

    echo "Setup ${COMPONENT} Service"
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
    StatusCheck $?

    systemctl daemon-reload &>>${LOG_FILE}
    systemctl enable ${COMPONENT} &>>${LOG_FILE}

    echo "Start ${COMPONENT} Service"
    systemctl start ${COMPONENT} &>>${LOG_FILE}
    StatusCheck $?

}

NODEJS() {
  echo "Downloading NodeJS Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
  StatusCheck $?


  echo "Installing NodeJS"
  yum install nodejs -y &>>${LOG_FILE}
  StatusCheck $?

 APP_PREREQ

  echo "Installing NodeJS Dependencies"
  npm install &>>${LOG_FILE}
  StatusCheck $?

  SYSTEMD_SETUP
}

APP_PREREQ() {
   id roboshop &>>${LOG_FILE}
    if [ $? -ne 0 ]; then
      echo "Add RoboShop Application User"
      useradd roboshop &>>${LOG_FILE}
      StatusCheck $?
    fi

    echo "Download ${COMPONENT} Application Code"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
    StatusCheck $?

    cd /home/roboshop

    echo "Cleaning Old App Content"
    rm -rf * ${COMPONENT} &>>${LOG_FILE}
    StatusCheck $?

    echo "Extract ${COMPONENT} Application Code"
    unzip /tmp/${COMPONENT}.zip  &>>${LOG_FILE}
    StatusCheck $?


    mv ${COMPONENT}-main ${COMPONENT}
    cd /home/roboshop/${COMPONENT}


}

JAVA() {
echo "Install Maven"
yum install maven -y &>>${LOG_FILE}
StatusCheck $?

APP_PREREQ

echo "Download Dependencies and Make Package"
mvn clean package &>>${LOG_FILE}
mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>${LOG_FILE}
StatusCheck $?


SYSTEMD_SETUP
}

PYTHON() {
  echo "Install python 3"
  yum install python36 gcc python3-devel -y &>>${LOG_FILE}
  StatusCheck $?

  APP_PREREQ

  cd /home/roboshop/${COMPONENT}

  echo "Install Python Dependencies for APP"
  pip3 install -r requirements.txt &>>${LOG_FILE}
  StatusCheck $?

  APP_UID=$(id -u roboshop)
  APP_GID=$(id -g roboshop)

  echo "Update Payment Configuration File"
  sed -i -e "/uid/ c uid = ${APP_UID}" -e "/gid/ c gid = ${APP_GID}" /home/roboshop/payment/payment.ini &>>${LOG_FILE}
  StatusCheck $?

  SYSTEMD_SETUP


}

