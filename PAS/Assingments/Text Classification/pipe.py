from transformers import pipeline
classifier = pipeline("text-classification", model="BAAI/bge-reranker-large")
res=classifier("ecommerceDataset.csv")
print(res)