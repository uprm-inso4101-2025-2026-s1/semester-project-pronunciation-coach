#!/usr/bin/env python3
"""
Download NLTK data with SSL workaround
Only use for local development!
"""

import ssl

import nltk

# Disable SSL verification (TEMPORARY WORKAROUND)
try:
    _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
    pass
else:
    ssl._create_default_https_context = _create_unverified_https_context

# Download required NLTK data
print("Downloading NLTK Brown corpus...")
nltk.download("brown", quiet=False)

print("\n✓ NLTK data downloaded successfully!")
print("You can now remove this file and use normal imports.")
