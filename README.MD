# Deploy Epoch Flask App to the AWS Lambda with Postgres RDS

This repository contains the source code of application **epoch.py** and deployment scripts with [Zappa](https://github.com/zappa/Zappa). 

# Preporation

You have to prepare AWS access (if you don't have it) and put it into **credentilas** file.
Also, you have to fill DB credentilas in **db.credentilas**

# Deploy

For deploy you should run the **deploy_stack.sh** scripts
`bash deploy_stack.sh`

* **NOTE:** in case if script hangs on "Creating RDS" you should press Ctrl+C to continue the script iteration* 