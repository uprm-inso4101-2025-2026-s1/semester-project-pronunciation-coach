import nltk
nltk.download('cmudict')
from nltk.corpus import cmudict

cmu_dict = cmudict.dict()

def Words_for_Quiz() -> list:
#Install nltk in CMD first to run this code

#CMUdict checks if the dictionary library is downloaded
#nltk.download('cmudict', quiet=True)

# Loads the CMU Pronouncing Dictionary
    cmu_dict = cmudict.dict()



# Creates an empty list for the practice words.
    wordList = []

# A while true that asks the user how many words they'd like to practice, prompting the user again if:
# 1) The number is a non-Integer.
# 2) The number is negative.
# Otherwise, the loop breaks and the user's input is accepted.

    while True:
        amount_str = input("How many words would you like to practice?: ").strip()
        try:
            amount = int(amount_str)
            if amount < 0:
                print("Please enter a non-negative number.")
                continue
            if amount == 0:
                print("Please enter a whole number.")
                continue
            break
        except ValueError:
            print("Please enter a whole number.")

# A while loop that prompts the user to enter each word.
# It also checks whether the user's entries meet the following conditions:
# 1) The word exists in the english vocabulary.
# 2) The word is not already in the list.
# If the conditions are not met, the program will ask the user to enter a valid input.
# If the conditions are met, the word will be added to the wordList and the program
# will continue prompting the user until the loop ends.

    while (amount != 0):
        word = input("Enter word: ")

    # Makes all of the user's entries lowercase and removes whitespaces to avoid errors.
        normalized = word.lower().strip()

        if (Word_Checker(normalized)==False) or (normalized in wordList):
            print("Please enter a valid word.")
        else: 
            (wordList.append(normalized))
            amount-=1
    else:
    # Prints the list of words for now.
        print("Words to practice:", wordList)
        return wordList

def Word_Checker(input_word: str) -> bool:

    #Checks if the given word exists in the CMU Pronouncing Dictionary.
    #Returns True if valid, False otherwise.

    return input_word.lower() in cmu_dict
######################
##### Test cases #####
######################

# Test 1: Standard

# - Input: amount = 3
# - Words: computer, apple, car
# - Expected Output: Words to practice: ['computer', 'apple', 'car']

# Test 2: Duplicate

# - Input: amount = 3
# - Words: computer, computer, Computer, COmPuTer, Apple, apple, car
# - Expected Output: Words to practice: ['computer', 'apple', 'car']

# Test 3: Non-existent word

# - Input: amount = 3
# - Words: coomputer, computer, apple, car
# - Expected Output: Words to practice: ['computer', 'apple', 'car']

# Test 3: Duplicate and non-existent word

# - Input: amount = 3
# - Words: computer, apple, Aplle, Apple, apple, caar, CAR
# - Expected Output: Words to practice: ['computer', 'apple','car']

# Test 4: Non-Integer amount

# - Input: amount = 3.5
# - Expected Output: Prompt the user again. "Please enter a whole number."

# Test 5: Negative amount

# - Input: amount = -3
# - Expected Output: Prompt the user again. "Please enter a non-negative number."

# Test 6: amount = 0

# - Input: amount = 0
# - Expected Output: Prompt the user again. "Please enter a whole number."

# Test 7: Empty

# - Input: amount = 3
# - Words: "", computer, "", apple, car
# - Expected Output: Words to practice: ['computer', 'apple', 'car']

# Note: noticed some words that exist in the english language are still unrecognized and marked as invalid.
# Also, phrases are not recognized.


#Note from issue #91 (Quiz with user input): code was modified slighlty to run the logic as a function ("Words_for_Quiz()") for use for the Quiz_with_user_input.py
#Note from issue #91 (Quiz with user input): file name was changed from "User.input.for.quiz.py" to "User_input_for_quiz.py" to avoid any issues with how Python interprets periods
#Note from issue #91 (Quiz with user input): to properly run this, the dev needs "nltk" downloaded on their device (Python library)