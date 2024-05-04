import numpy as np
import matplotlib.pyplot as plt

# Mean value of the Poisson distribution
lambda_val = 0.7

# Calculate probabilities for k = 0, 1, 2, 3, and 4
probs = [np.exp(-lambda_val) * (lambda_val**k) / np.math.factorial(k) for k in range(5)]

# Create histogram
plt.bar(range(5), probs, color='skyblue')

# Add labels and title
plt.xlabel('Number of Failures')
plt.ylabel('Probability')
plt.title('Probability of Failures in a Week (Poisson, λ=0.7)')

# Show plot
plt.xticks(range(5))
plt.grid(axis='y')
plt.tight_layout()
plt.show()
