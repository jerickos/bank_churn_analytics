import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import statsmodels.api as sm
import numpy as np



#load data
bankMarketing = pd.read_csv("C:/Users/jeric/OneDrive/Desktop/sqlProjects/bank/bank.csv", sep = ";")

bankMarketing['y'] = bankMarketing['y'].map({'no':0, 'yes':1})

# Select predictors
X = bankMarketing[['age','balance','duration']]
X = sm.add_constant(X)
y = bankMarketing['y']

# Logistic regression
model = sm.Logit(y, X).fit()
print(model.summary())

print(np.exp(model.params))


# Get means of predictors
mean_age = bankMarketing['age'].mean()
mean_balance = bankMarketing['balance'].mean()
mean_duration = bankMarketing['duration'].mean()

# Age effect
age_range = np.linspace(bankMarketing['age'].min(), bankMarketing['age'].max(), 100)
X_age = pd.DataFrame({'const':1, 'age':age_range, 'balance':mean_balance, 'duration':mean_duration})
y_age = model.predict(X_age)

plt.plot(age_range, y_age)
plt.xlabel("Age")
plt.ylabel("Predicted Probability of Subscription")
plt.title("Effect of Age on Subscription")
plt.show()

# Balance effect
balance_range = np.linspace(bankMarketing['balance'].min(), bankMarketing['balance'].max(), 100)
X_balance = pd.DataFrame({'const':1, 'age':mean_age, 'balance':balance_range, 'duration':mean_duration})
y_balance = model.predict(X_balance)

plt.plot(balance_range, y_balance)
plt.xlabel("Balance")
plt.ylabel("Predicted Probability of Subscription")
plt.title("Effect of Balance on Subscription")
plt.show()

# Duration effect
duration_range = np.linspace(bankMarketing['duration'].min(), bankMarketing['duration'].max(), 100)
X_duration = pd.DataFrame({'const':1, 'age':mean_age, 'balance':mean_balance, 'duration':duration_range})
y_duration = model.predict(X_duration)

plt.plot(duration_range, y_duration)
plt.xlabel("Call Duration (seconds)")
plt.ylabel("Predicted Probability of Subscription")
plt.title("Effect of Duration on Subscription")
plt.show()

fig, axes = plt.subplots(1, 3, figsize=(18, 5))

axes[0].plot(age_range, y_age, color='blue')
axes[0].set_title("Effect of Age")

axes[1].plot(balance_range, y_balance, color='green')
axes[1].set_title("Effect of Balance")

axes[2].plot(duration_range, y_duration, color='red')
axes[2].set_title("Effect of Duration")

plt.tight_layout()
plt.show()
