import json, os
from flask import Flask, request, jsonify
from datetime import datetime
import psycopg2
from psycopg2.extras import LoggingConnection

#TABLE_NAME = "user_registration"

DB_SETTINGS = {
    "host": os.getenv('DB_INSTANCE'),
    "database": "fingerprint",
    "user": os.getenv('DB_USER'),
    "password": os.getenv('DB_USER_PASSWORD')
}

app = Flask(__name__)
app.config["DEBUG"] = True

try:
    conn = psycopg2.connect(
        connection_factory=LoggingConnection,
        **DB_SETTINGS )
    conn.initialize(app.logger)
    app.logger.info("SUCCESS: Connection to RDS Postgres instance succeeded")
except InterruptedError as e:
    app.logger.error("ERROR: Unexpected error: Could not connect to RDS instance.")
    app.logger.error(e)


@app.route('/', methods=['GET'])
def home():
    return ''' <h1>Epoch service</h1>
<p>API for getting users fingerprints.</p>'''


@app.route('/api/v1/users/add', methods=['PUT'])
def add_user():
    payload = json.loads(request.data)
    cur = conn.cursor()
    cur.execute('INSERT into user_registration (timestamp,payload) VALUES(%s,%s)',
                ( (datetime.now().strftime("%d-%b-%Y (%H:%M:%S)")),(json.dumps(payload)) ))
    conn.commit()
    cur.close()
    return jsonify(datetime.now())

@app.route('/api/v1/users/last', methods=['GET'])
def get_last_user():
    cur = conn.cursor()
    cur.execute("select timestamp,payload from user_registration where id = (select MAX(id) from user_registration)")
    last_user = cur.fetchall()
    cur.close()
    return jsonify(last_user)

@app.route('/api/v1/users/last10', methods=['GET'])
def get_all_users():
    cur = conn.cursor()
    cur.execute('select id,timestamp,payload from user_registration where payload is not NUll limit 10')
    all_users = cur.fetchall()
    cur.close()
    return jsonify(all_users)
