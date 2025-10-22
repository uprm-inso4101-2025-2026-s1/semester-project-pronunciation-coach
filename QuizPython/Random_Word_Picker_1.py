import nltk
from nltk.corpus import wordnet
from nltk.corpus import words
from nltk.corpus import brown
from collections import Counter
import random

nltk.download("wordnet")

wordsl = list(set(wordnet.all_lemma_names()))
random_word = random.choice(wordsl)
print(random_word)

Vl_word = [w for w in wordsl if len(w) == 5]
Vl_random_word = random.choice(Vl_word)
print(Vl_random_word)

IIIl_word = [w for w in wordsl if len(w) == 3]
IIIl_random_word = random.choice(IIIl_word)
print(IIIl_random_word)

nltk.download("words")

word_list = words.words()
print(len(word_list))
print(random.choice(word_list))

nltk.download("brown")

print("----------------------------------------")

freq = Counter(w.lower() for w in brown.words() if w.isalpha())
#print(freq)
word_list = set(words.words())
common_words = [w for w, c in freq.most_common(50) if w in word_list]
print(common_words)

common = [w for w, c in freq.most_common(15000) if w.isalpha()]

print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
print(random.choice(common))
