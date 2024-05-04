import pandas as pd

# Existing test dataset
test_data = {
    'text': [
        "This movie is amazing! I loved the plot and the acting.",
        "The weather is fantastic today. Perfect for outdoor activities.",
        "I'm not sure if I like this new product. It's not meeting my expectations.",
        "Feeling great after the morning workout session.",
        "The customer service was terrible. I had a bad experience.",
        "Just finished reading the latest novel. Highly recommended!"
    ],
    'label': ['Positive', 'Positive', 'Negative', 'Positive', 'Negative', 'Positive']
}

# Add 1000 more rows manually
for _ in range(1000):
    new_row = {
        'text': "Manually added text.",
        'label': 'Positive' if _ % 2 == 0 else 'Negative'
    }
    test_data['text'].append(new_row['text'])
    test_data['label'].append(new_row['label'])

# Create a DataFrame from the updated dictionary
test_df = pd.DataFrame(test_data)

# Save the updated DataFrame to a CSV file
test_df.to_csv('updated_test_text_classification_dataset.csv', index=False)

# Display the updated test dataset
print(test_df)

