#!/bin/bash
#deploy RDS Postgres
echo "Creating RDS"
source db.credentials
docker run -it -v ~/.aws:/root/.aws amazon/aws-cli rds create-db-instance \
    --engine postgres \
    --db-instance-class db.t2.micro \
    --allocated-storage 20 \
    --db-instance-identifier newmotion \
    --db-name fingerprint \
    --master-username ${DB_USER} \
    --master-user-password ${DB_USER_PASSWORD} >>log.txt 2>&1

echo "SUCCESS"

#waiting for creation BE
echo "Waiting for service to be up and running"
sleep 300
#load database address
docker run -it -v ~/.aws:/root/.aws amazon/aws-cli rds \
    --region eu-west-2 describe-db-instances \
    --query "DBInstances[*].Endpoint.Address" \
    --db-instance-identifier newmotion | grep "com" | awk -F'"' '{print $2}' > db.instance

# create table in the DB
DB_HOST=`cat db.instance`
dir=`pwd`
echo $dir
docker run -it -v "${dir}":/tmp/ postgres:12 psql --host=${DB_HOST} --dbname=fingerprint \
     --username=${DB_USER} -W \
     -a -f /tmp/user_registration.sql

#build docker image for zappa deployment
docker build -t newmotion-aws-deploy:latest . 

#deploy FE
docker run newmotion-aws-deploy:latest