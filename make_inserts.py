import pandas as pd

files = [
    r"data\marque.xlsx",
    r"data\ingredient.xlsx",
    r"data\boisson.xlsx",
    r"data\focaccia.xlsx",
]

for f in files:
    try:
        pd.read_excel(f, engine="openpyxl")
        print(f"OK: {f}")
    except Exception as e:
        print(f"ERREUR: {f}")
        print(e)
