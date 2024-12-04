from typing import Optional
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

MIN_SIMILARITY_THRESHOLD = 0.1

# Load the uploaded CSV file to check its structure and content
file_path = 'nutrition.csv'
data = pd.read_csv(file_path)

# Define the columns to search in
search_columns = ['Food Name', 'Food Description']

# Combine the relevant columns into a single searchable text for each row
data['search_text'] = data[search_columns].fillna('').apply(' '.join, axis=1)

# Vectorise
vectoriser = TfidfVectorizer()
tfidf_matrix = vectoriser.fit_transform(data['search_text'])

def nutrition_search(query: Optional[str]):
    # Compute TF-IDF for the dataset and the query
    query_vector = vectoriser.transform([query])

    # Compute cosine similarity between the query and all rows
    cosine_similarities = cosine_similarity(query_vector, tfidf_matrix).flatten()

    # Get the index of the most similar row
    most_similar_idx = cosine_similarities.argmax()
    if cosine_similarities[most_similar_idx] < MIN_SIMILARITY_THRESHOLD:
        return None

    most_similar_row = data.iloc[most_similar_idx]

    # Display the most relevant result
    # return most_similar_row[['Public Food Key', 'Food Name', 'Classification Name', 'Food Description']]
    return most_similar_row