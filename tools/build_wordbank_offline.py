# usage: python tools/build_wordbank_offline.py tools/words_alpha.txt QuizPython/wordbank.json
# requires: pip install pronouncing

import json, os, re, sys
import pronouncing

# --- ARPABET -> IPA mapping ---
ARPA_TO_IPA = { # Conversions from CMUdict ARPABET to IPA.
  "AA":"ɑ", "AE":"æ", "AH":"ʌ", "AO":"ɔ", "AW":"aʊ", "AY":"aɪ",
  "EH":"ɛ", "ER":"ɝ", "EY":"eɪ", "IH":"ɪ", "IY":"i", "OW":"oʊ",
  "OY":"ɔɪ", "UH":"ʊ", "UW":"u",
  "P":"p","B":"b","T":"t","D":"d","K":"k","G":"ɡ","CH":"tʃ","JH":"dʒ",
  "F":"f","V":"v","TH":"θ","DH":"ð","S":"s","Z":"z","SH":"ʃ","ZH":"ʒ",
  "HH":"h","M":"m","N":"n","NG":"ŋ","L":"l","R":"ɹ","Y":"j","W":"w"
}
VOWELS = {"AA","AE","AH","AO","AW","AY","EH","ER","EY","IH","IY","OW","OY","UH","UW"} # ARPABET vowels

def norm(w: str) -> str:
  # Returns the normalized word. Lowercase, trim, and removed surrounding punctuation/spaces.
  return re.sub(r"[^\w'-]", "", w.strip().lower())

def arpa_tokens(phones: str):
  # Returns a list of ARPABET tokens with stress digits stripped.
  return [re.sub(r"\d","",p) for p in phones.split()]

def to_ipa(tokens):
  # Converts a list of ARPABET tokens to an IPA string.
  return "".join(ARPA_TO_IPA.get(t, t.lower()) for t in tokens)

def syllabify(tokens):
  # Starts a new syllable whenever a vowel is encountered (after the first token).
  syls, cur = [], [] # list of syllables, current syllable
  for t in tokens: # For each ARPABET token,
    if t in VOWELS and cur: # if it's a vowel and the current syllable is not empty,
      syls.append(cur); cur=[t] # start a new syllable.
    else:
      cur.append(t) # Otherwise, add the token to the current syllable.
  if cur: syls.append(cur)
  # Returns IPA syllables.
  return [to_ipa(s) for s in syls]

def build_entry(word: str):
  # Builds a word entry using the CMUdict pronouncing library.
  prons = pronouncing.phones_for_word(word) # Using the pronouncing library to get the word's pronunciation.
  if not prons:
    return None  # Returns none if it's not in CMUdict.
  toks = arpa_tokens(prons[0])  # Takes the first pronunciation and converts it to ARPABET tokens.
  ipa  = f"/{to_ipa(toks)}/" # Converts the tokens to an IPA string.
  syls = syllabify(toks) # Calls the syllabify function to convert the tokens into IPA syllables.
  return {"ipa": ipa, "syllables": syls, "source": "cmudict-offline"} # Returns the word entry as a dictionary.

def read_words(path: str):
  # Reads the words from a file, trying multiple encodings.
  for enc in ("utf-8", "utf-8-sig", "utf-16", "utf-16-le", "utf-16-be"): # Builds tolerance for different file encodings (windows files etc.).
    try:
      with open(path, "r", encoding=enc) as f: # Tries to open the file with the current encoding.
        return [norm(x) for x in f if x.strip()] # Returns the normalized words.
    except UnicodeDecodeError: # If a UnicodeDecodeError occurs, it tries the next encoding.
      continue
  with open(path, "r", encoding="utf-8", errors="ignore") as f: # If all else fails, opens the file with utf-8 and ignores errors.
    return [norm(x) for x in f if x.strip()] # Returns the normalized words.

def main(infile: str, outfile: str):
  # Main function to build the word bank from the input file and write it to the output file.
  words = read_words(infile) # Reads the words from the input file.
  bank = {} # Initializes an empty dictionary to hold the word bank.
  hits = misses = 0 # Counters for successful and failed entries.
  total = len(words) # Total number of words to process.
  for i, word in enumerate(words, 1): 
    # Processes each word, building its entry and adding it to the bank.
    if not word: continue # Skips empty words.
    entry = build_entry(word) # Builds the word entry.
    if entry:
      bank[word] = entry # Adds the entry to the bank if it was successfully built.
      hits += 1 # Adds one to the hits counter.
    else:
      misses += 1 # Else, adds one to the misses counter.
    if i % 50 == 0 or i == total: # Every 50 words or at the end, prints progress.
      print(f"Processed {i}/{total}  (ok: {hits}  miss: {misses})")

  # Writes the word bank to the output JSON file.
  os.makedirs(os.path.dirname(outfile) or ".", exist_ok=True)
  with open(outfile, "w", encoding="utf-8") as f:
    json.dump(bank, f, ensure_ascii=False, indent=2)
  print(f"Wrote {len(bank)} entries -> {outfile}")

if __name__ == "__main__":
  in_path  = sys.argv[1] if len(sys.argv) >= 2 else "tools/words_alpha.txt"
  out_path = sys.argv[2] if len(sys.argv) >= 3 else "QuizPython/wordbank.json"
  print(f"[offline builder] input={in_path}  output={out_path}")
  main(in_path, out_path)