import nltk
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import string
import csv
x=[]
y=[]
with open(r"C:\Users\user\PycharmProjects\detecths\dataset.csv", mode ='r') as file:
  csvFile = csv.reader(file)
  for lines in csvFile:
      try:
        print(lines)
        lines=lines[0].split("\t")
        id=int(lines[5])
        x.append(lines[6])
        y.append(lines[5])
      except:
          pass
print(x)
print(y)
def  text_similarity(para1,para2):
    # Tokenization
    tokens1 = nltk.word_tokenize(para1.lower())
    tokens2 = nltk.word_tokenize(para2.lower())

    # Stopword removal
    stop_words = set(stopwords.words('english'))
    tokens1 = [w for w in tokens1 if w not in stop_words and w not in string.punctuation]
    tokens2 = [w for w in tokens2 if w not in stop_words and w not in string.punctuation]

    # Stemming
    stemmer = PorterStemmer()
    tokens1 = [stemmer.stem(w) for w in tokens1]
    tokens2 = [stemmer.stem(w) for w in tokens2]

    # Join tokens
    text1 = " ".join(tokens1)
    text2 = " ".join(tokens2)

    # Vectorization
    vectorizer = CountVectorizer()
    vectors = vectorizer.fit_transform([text1, text2])

    # Cosine similarity
    similarity = cosine_similarity(vectors[0], vectors[1])

    print("Cosine Similarity:", similarity[0][0])
    return similarity[0][0]


def detect_txt_type(txt):
    reslist=[]
    for i in range(len(x)):
        res=text_similarity(txt,x[i])
        reslist.append({"y":y[i],"sim":res})
    reslist.sort(key=lambda x: x["sim"], reverse=True)
    return reslist[0]["y"],round(reslist[0]["sim"]*100,2)




# print(detect_txt_type("get out you bitch"))