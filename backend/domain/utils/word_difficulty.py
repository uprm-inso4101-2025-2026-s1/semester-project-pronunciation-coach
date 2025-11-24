"""
Word difficulty classifier based on spelling patterns.
Original author: iralys-sanchez18

This module exposes:

 classify_word_difficulty(word: str) -> strcategorize(word) -> rich profile (score, features, level as "Easy/Intermediate/Hard")
 classify_word_difficulty(word) -> "easy" | "medium" | "hard"

- rare letters / patterns make words harder
- consonant clusters are harder
- more syllables are harder
- longer words are harder
- more "stress complexity" is harder

Returns one of: "easy", "medium", "hard".

Make sure NLTK and cmudict are installed in the backend venv:

pip install nltk
python -m nltk.downloader cmudict

"""

from typing import List, Dict, Optional, Literal
from functools import lru_cache

# Loads the CMU Pronouncing Dictionary
try:
    from nltk.corpus import cmudict 
    cmu_dict = cmudict.dict()
except Exception:
    cmu_dict = None

if cmu_dict is None:
    print("[WordDifficulty] WARNING: cmudict not available, defaulting all words to 'medium'")

# Declaration of difficulty levels.
Level = Literal["Easy","Intermediate","Hard"]

### Configuration ###

CONFIG = {
    "VOWELS": {"AA","AE","AH","AO","AW","AY","EH","ER","EY","IH","IY","OW","OY","UH","UW",}, # CMUdict ARPABET vowel set.
    "RARE":   {"TH","DH","ZH","SH","CH","JH","R","AE","IH","UH"}, # Harder-to-pronounce phones.
    "WEIGHTS": {                     # How much each feature contributes to the final score. Higher = more impact.
        "rare_ratio": 1.3,
        "clusters":   1.0,
        "syllables":  0.4,
        "length":     0.2,
        "stress":     0.4,           
    },
    "THRESHOLDS": {     # Level thresholds
        "easy_max": 1.0,
        "intermediate_max": 2.0,    # > this -> Hard
    },
}

# Function that categorizes a word based on its CMUdict pronunciation features.
# Alphabet used: ARPABET
# Returns: { 'word','phones','score','level','features':{...} }
# OOV/Empty: word=word, phones=None, score=None, level='Intermediate'.
# Takes a string and returns a dictionary with the word's categorization details.
def categorize(word: str) -> Dict[str, object]:

    # Stress digits are stripped for most features. However, the raw stressed phones are used to compute stress_complexity.
    
    # Normalizes input by trimming whitespace and turning it to lowercase.
    # In the case of None/empty, input is turned into "".
    w = (word or "").strip().lower()

    # If word is empty or None after normalization, return unknown.
    if not w:
        return _unknown(w)
    
    # Contain ARPABET phones (with stress digits). Used to calculate stress_complexity.
    raw = _cmu_lookup(w)

    # If the word is not found in the CMUdict lookup, return unknown.
    if raw is None:
        return _unknown(w)

    # Removes stress digits by stripping trailing digits from each phone. These phones are used for features like syllable count and clusters.
    phones = [p.rstrip("012") for p in raw]

    # Pulls the values from the config for easier access.
    VOWELS = CONFIG["VOWELS"]       # ARPABET vowel set.
    RARE   = CONFIG["RARE"]         # Harder-to-pronounce phones.
    W      = CONFIG["WEIGHTS"]      # How much each feature contributes to the final score.
    T      = CONFIG["THRESHOLDS"]   # Limits that map the score to the level.

    ### Feature calculations ###

    total = max(1, len(phones)) # Avoids division by zero. If phones is empty, total is set to 1.
    rare_ratio = sum(p in RARE for p in phones) / total # Counts how many phones are in the RARE set, divided by total phones.
    syllables  = sum(p in VOWELS for p in phones) # Counts how many phones are in the VOWELS set.
    clusters   = _count_consonant_clusters(phones, VOWELS) # Counts consonant clusters (2+ consonants in a row).
    length     = max(0.0, (len(phones) - 6) / 6.0) # Length penalty that starts growing for words longer than 6 phones.

    # stress_complexity = (# stressed syllables - 1, clamped at 0)
    stress_marks = sum(p.endswith(("1","2")) for p in raw)
    stress       = float(max(0, stress_marks - 1))

    ### Score and level determination ###

    # Calculates a weighted sum of the features to get a final score. Weighted sum = Σ w_i * feature_i
    score = (W["rare_ratio"] * rare_ratio +
             W["clusters"]   * clusters +
             W["syllables"]  * syllables +
             W["length"]     * length +
             W["stress"]     * stress)

    # Determines the level based on the score and the thresholds from the config.
    easy_max = T["easy_max"]
    interm_max = T["intermediate_max"]
    
    level: Level = (
        "Easy"
        if score <= easy_max                 # score <= easy_max -> Easy
        else "Intermediate"
        if score <= interm_max  # easy_max < score <= interm_max -> Intermediate
        else "Hard"
    )                                # interm_max < score -> Hard

    # Returns the assembled word profile.
    return {
        "word": w,  # Normalized input.
        "phones": phones,   # Stress stripped phones.
        "score": round(score, 3),   # Difficulty score rounded to 3 decimals.
        "level": level,     # Difficulty level: Easy/Intermediate/Hard
        "features": { # Detailed components of the score for debugging.
            "rare_ratio": round(rare_ratio, 3),
            "clusters": float(clusters),
            "syllables": float(syllables),
            "length": round(length, 3),
            "stress_complexity": float(stress),
        }
    }

# Function that counts consonant clusters in a list of phones.
def _count_consonant_clusters(phones: List[str], VOWELS: set) -> int:
    
    # Keeps track of the total number of clusters and the current length of the consonant streak.
    total, current = 0, 0

    # Iterates through each phone in the list.
    for p in phones:
        if p not in VOWELS: # Adds 1 to the current consonant streak if the phone is a consonant.
            current += 1
        else:
            if current >= 2:
                total += 1 # If the streak ends and current is 2 or more, then it's a cluster.
            current = 0 # Resets current to 0.
    return total + (1 if current >= 2 else 0)  # Returns the total clusters, adding 1 if the list ends with a cluster.

# Cached CMUdict lookup to avoid repeated expensive calls.
@lru_cache(maxsize=4096)
def _cmu_lookup(word: str) -> Optional[List[str]]: # Function that looks up a word in the CMU Pronouncing Dictionary and returns its raw phonetic sequence.
    if not cmu_dict:
        return None
    seqs = cmu_dict.get(word) # seq is a list since a word can have multiple pronunciations. This returns seq[0], which is the first pronunciation.
    return list(seqs[0]) if seqs else None # Returns the first pronunciation if it exists, else None.

# Function that returns a default word profile if the input doesn't exist.
def _unknown(word: str = "") -> Dict[str, object]:
    return {
        "word": word,
        "phones": None,
        "score": None,
        "level": "Intermediate",
        "features": {"unknown": True},
    }

@lru_cache(maxsize=100_000)
def classify_word_difficulty(word: str) -> str:

    # Maps ARPABET-based difficulty to quiz labels: "easy" | "medium" | "hard".

    profile = categorize(word)
    level = profile.get("level", "Intermediate")

    mapping = {
        "Easy": "easy",
        "Intermediate": "medium",
        "Hard": "hard",
    }
    return mapping.get(level, "medium")