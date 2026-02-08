from flask import Flask, render_template, request
import joblib
import numpy as np
import pymysql

# Initialize Flask app
app = Flask(__name__)

# Load ML model and encoders
model = joblib.load('rf_fraud_model.pkl')
encoders = joblib.load('rf_encoders.pkl')

# Connect to MySQL
def get_db_connection():
    return pymysql.connect(
        host='localhost',
        user='root',
        password='Root',
        db='DBMS',
        cursorclass=pymysql.cursors.DictCursor
    )

# Encoding input for the model
def encode_input(data):
    encoded = []
    for i, col in enumerate(['recipient', 'location', 'device_type', 'txn_type']):
        le = encoders[col]
        val = data[i]
        if val not in le.classes_:
            le.classes_ = np.append(le.classes_, 'unknown')
            val = 'unknown'
        encoded.append(le.transform([val])[0])
    return [data[0]] + encoded + [data[5]]  # amount + 4 encoded fields + frequency

@app.route('/', methods=['GET', 'POST'])
def index():
    result = None
    connection = None  # ✅ Prevents UnboundLocalError

    if request.method == 'POST':
        amount = float(request.form['amount'])
        recipient = request.form['recipient']
        location = request.form['location']
        device_type = request.form['device_type']
        txn_type = request.form['txn_type']
        frequency = int(request.form['frequency'])

        data = [amount, recipient, location, device_type, txn_type, frequency]
        input_vector = encode_input(data)
        prediction = model.predict([input_vector])[0]
        is_fraud = int(prediction)

        result = '⚠️ Warning: Fraud Detected!' if is_fraud else '✅ Transaction is Safe'

        try:
            connection = get_db_connection()
            with connection.cursor() as cursor:
                query = """
                    INSERT INTO transactions (
                        user_id, amount, recipient, merchant, location,
                        device_type, txn_type, frequency, is_fraud, user_name
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """
                cursor.execute(query, (
                    1, amount, recipient, 'WebAppUser', location,
                    device_type, txn_type, frequency, is_fraud, 'Test User'
                ))
                connection.commit()
        except Exception as e:
            result += f" [DB Error: {e}]"
        finally:
            if connection:
                connection.close()

    return render_template('index.html', result=result)

if __name__ == '__main__':
    app.run(debug=True)
