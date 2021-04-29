#!/bin/bash
#deploy FE
WORKDIR=`pwd`

cd ${WORKDIR}
echo $WORKDIR
# move credentilas
mkdir ~/.aws 
mv credentials ~/.aws/

#INSTALL virtualenv and pyenv for zappa deploy
pip install virtualenv pipenv
which virtualenv
virtualenv /opt/aws/zappa_app
ls -lah
# Activate venv and install requirements
source zappa_app/bin/activate
pipenv install flask psycopg2 psycopg2-aws zappa
ls -lah
pip install -r requirements.txt

#PUT DB address and creds into zappa_settings
DB_HOST=`cat db.instance`

source db.credentials

echo $DB_HOST | sed -i -E "s/database_host/${DB_HOST}/g" zappa_settings.json 

sed -i -E "s/user_name/${DB_USER}/g" zappa_settings.json 
sed -i -E "s/user_password/${DB_USER_PASSWORD}/g" zappa_settings.json 

#Deploy or update FE instacnes
zappa deploy euwest2 && set e
if [[ e != 0 ]]; then 
  zappa update euwest2 
fi
zappa deploy euwest1 && set e
if [[ e != 0 ]]; then
  zappa update euwest1
  fi