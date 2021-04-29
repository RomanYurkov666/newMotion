FROM python:3.8

RUN mkdir /opt/aws/
WORKDIR /opt/aws/

COPY ["deploy_fe.sh", "credentials", "epoch.py", "requirements.txt", "zappa_settings.json", "db.instance", "db.credentials", "./"] 

CMD ["bash", "deploy_fe.sh"]