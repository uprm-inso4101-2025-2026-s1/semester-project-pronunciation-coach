import nltk
from nltk.corpus import brown
from nltk.corpus import words
from collections import Counter
import random

nltk.download("brown")


#Returns a completely random English word
def Get_Random_English_Word() -> str:
    word_list = [w for w in brown.words() if (len(w) > 3) and (w.isalpha())] #Filters out any words that have symbols and words with 3 letters or less
    return random.choice(word_list).lower()

#Returns a top nth commonly used word (the higher the)
def Get_Random_Top_nth_Common_Word(n:int) -> str:
    frequency = Counter(w.lower() for w in brown.words() if w.isalpha()) #Creates a dictionary with a word:frequency
    #word_list = set(words.words())
    common_words = [w for w, c in frequency.most_common(n) if w.isalpha()] #Filter out words that're not with the top nth commonly used words
    return random.choice(common_words)

#print(Get_Random_English_Word())
#print(Get_Random_Top_nth_Common_Word(1000))