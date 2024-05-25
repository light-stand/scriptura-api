# Path: data/scripts/1716225521883_testaments.py

import pandas as pd
import utils.random as random

testaments = {
    "id": [1, 2],
    "uid": [random.random_string(12), random.random_string(12)],
    "name": ["Old Testament", "New Testament"],
    "slug": ["old", "new"],
    "code": ["OT", "NT"],
}

df = pd.DataFrame(testaments)

print(df)

df.to_csv("data/output/1716225521883_testaments.csv", index=False)
