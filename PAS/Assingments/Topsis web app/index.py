from flask import Flask, render_template, request, send_file
import pandas as pd
import numpy as np
import os
from flask_mail import Mail, Message

app = Flask(__name__)

# Flask-Mail Configuration
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USE_SSL'] = True
app.config['MAIL_USERNAME'] = '2003pulkit@gmail.com'  # Your Gmail username
app.config['MAIL_PASSWORD'] = 'rkiq uskn hvsm wuok'  # Your Gmail password

mail = Mail(app)

def load_input_data(input_file):
    try:
        data = pd.read_csv(input_file)
        return data
    except FileNotFoundError:
        return None

def validate_numeric_values(data):
    non_numeric_columns = data.iloc[:, 1:].applymap(lambda x: not np.isreal(x)).any()
    if non_numeric_columns.any():
        return False
    return True

def validate_weights_impacts(weights, impacts, num_columns):
    weights_list = list(map(int, weights.split(',')))
    impacts_list = impacts.split(',')

    if len(weights_list) != num_columns - 1 or len(impacts_list) != num_columns - 1:
        return False

    if not all(impact in ['+', '-'] for impact in impacts_list):
        return False

    return True

def calculate_custom_score(data, weights, impacts):
    normalized_data = data.iloc[:, 1:].apply(lambda x: x / np.sqrt(np.sum(x**2)), axis=0)
    weighted_normalized_data = normalized_data * list(map(int, weights.split(',')))
    ideal_best = weighted_normalized_data.max() if impacts[0] == '+' else weighted_normalized_data.min()
    ideal_worst = weighted_normalized_data.min() if impacts[0] == '+' else weighted_normalized_data.max()
    custom_score = np.sqrt(np.sum((weighted_normalized_data - ideal_best)**2, axis=1)) / (
            np.sqrt(np.sum((weighted_normalized_data - ideal_best)**2, axis=1)) +
            np.sqrt(np.sum((weighted_normalized_data - ideal_worst)**2, axis=1))
    )
    return custom_score

@app.route('/', methods=['GET', 'POST'])
def index():
    email_sent = False
    if request.method == 'POST':
        input_file = request.files['input_file']
        weights = request.form['weights']
        impacts = request.form['impacts']
        email = request.form['email']

        if not input_file or not weights or not impacts or not email:
            return render_template('index.html', error="Please provide all required fields.")

        data = load_input_data(input_file)
        if data is None:
            return render_template('index.html', error="Invalid input file. Please provide a valid CSV file.")

        if not validate_numeric_values(data):
            return render_template('index.html', error="Columns from 2nd to last must contain numeric values only.")

        if not validate_weights_impacts(weights, impacts, len(data.columns)):
            return render_template('index.html', error="Invalid weights or impacts.")

        custom_score = calculate_custom_score(data, weights, impacts)
        data['Custom Score'] = custom_score
        data['Rank'] = data['Custom Score'].rank(ascending=False)

        # Save result to a temporary directory
        result_filename = os.path.join(app.root_path, 'result.csv')
        data.to_csv(result_filename, index=False)

        # Send email with result CSV attached
        msg = Message('TOPSIS Result', sender='2003pulkit@gmail.com', recipients=[email])
        msg.body = f"Dear User,\n\nAttached is the TOPSIS result CSV file you requested.\n\nBest regards,\nPulkit Arora\n\nLinkedIn: https://www.linkedin.com/in/pulkit-arora-731b17227/"
        with app.open_resource(result_filename) as fp:
            msg.attach('result.csv', "text/csv", fp.read())
        mail.send(msg)

        # Cleanup: Remove the temporary result CSV file
        os.remove(result_filename)

        email_sent = True

    return render_template('index.html', email_sent=email_sent)

if __name__ == "__main__":
    app.run(debug=True)
