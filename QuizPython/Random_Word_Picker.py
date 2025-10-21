import nltk
from nltk.corpus import brown
from nltk.corpus import words
from collections import Counter
import random

nltk.download("brown")
nltk.download("words")

def Get_Random_English_Word() -> str:
    return random.choice(brown.words())

def Get_Random_Top_nth_Common_Word(n:int) -> str:
    frequency = Counter(w.lower() for w in brown.words() if w.isalpha())
    #word_list = set(words.words())
    common_words = [w for w, c in frequency.most_common(n) if w.isalpha()]
    return random.choice(common_words)

print(Get_Random_English_Word())
print(Get_Random_Top_nth_Common_Word(1000))