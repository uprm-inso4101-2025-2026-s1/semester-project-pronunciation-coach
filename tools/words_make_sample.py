import random

# Creates a sample by grabbing 700 random words from words_sample.txt and writing them to a txt file. Unused at the moment.

source = "tools/words_sample.txt"
output = "tools/words_sample_700.txt"

with open(source, "r", encoding="utf-8") as f:
    words = [w.strip() for w in f if w.strip()]

sample = random.sample(words, 700)
with open(output, "w", encoding="utf-8") as f:
    f.write("\n".join(sample))

print(f"Created {output} with {len(sample)} random words.")
