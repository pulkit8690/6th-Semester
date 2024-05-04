import sys
import pandas as pd
import numpy as np

def validate_input_parameters():
    if len(sys.argv) < 5:
        #print("Usage: python <program.py> <InputDataFile> <Weights> <Impacts> <ResultFileName>")
        sys.exit(1)

def load_input_data(input_file):
    try:
        data = pd.read_csv(input_file)
        return data
    except FileNotFoundError:
        print("File not found. Please provide a valid input file.")
        sys.exit(1)

def validate_data_columns(data):
    if len(data.columns) < 3:
        print("Input file must contain three or more columns.")
        sys.exit(1)

def validate_numeric_values(data):
    non_numeric_columns = data.iloc[:, 1:].applymap(lambda x: not np.isreal(x)).any()
    if non_numeric_columns.any():
        print("Columns from 2nd to last must contain numeric values only.")
        sys.exit(1)

def validate_weights_impacts(weights, impacts, num_columns):
    weights_list = list(map(int, weights.split(',')))
    impacts_list = impacts.split(',')

    if len(weights_list) != num_columns - 1 or len(impacts_list) != num_columns - 1:
        print("Number of weights, impacts, and columns must be the same.")
        sys.exit(1)

    if not all(impact in ['+', '-'] for impact in impacts_list):
        print("Impacts must be either +ve or -ve.")
        sys.exit(1)

def normalize_input_data(data):
    normalized_data = data.iloc[:, 1:].apply(lambda x: x / np.sqrt(np.sum(x**2)), axis=0)
    return normalized_data

def calculate_custom_score(data, weights, impacts):
    normalized_data = normalize_input_data(data)
    weighted_normalized_data = normalized_data * list(map(int, weights.split(',')))
    ideal_best = weighted_normalized_data.max() if impacts[0] == '+' else weighted_normalized_data.min()
    ideal_worst = weighted_normalized_data.min() if impacts[0] == '+' else weighted_normalized_data.max()
    custom_score = np.sqrt(np.sum((weighted_normalized_data - ideal_best)**2, axis=1)) / (
            np.sqrt(np.sum((weighted_normalized_data - ideal_best)**2, axis=1)) +
            np.sqrt(np.sum((weighted_normalized_data - ideal_worst)**2, axis=1))
    )
    return custom_score

def perform_analysis():
    validate_input_parameters()
    input_file = sys.argv[1]
    weights = sys.argv[2]
    impacts = sys.argv[3]
    result_file = sys.argv[4]

    data = load_input_data(input_file)
    validate_data_columns(data)
    validate_numeric_values(data)
    validate_weights_impacts(weights, impacts, len(data.columns))

    custom_score = calculate_custom_score(data, weights, impacts)
    data['Custom Score'] = custom_score
    data['Rank'] = data['Custom Score'].rank(ascending=False)

    data.to_csv(result_file, index=False)
    print("Custom analysis completed. Result saved to {result_file}")

if __name__ == "__main__":
    perform_analysis()
