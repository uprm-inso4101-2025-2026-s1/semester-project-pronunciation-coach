# import json
# import os
import random
from User_input_for_quiz import *
from Random_Word_Picker import *
from I_want_to_finish_this_shit import *
#import nltk
#nltk.download('cmudict')
#from nltk.corpus import cmudict

#Initializes
#cmu_dict = cmudict.dict()

# #Finds the file where the dictionary is with all the English words with its corresponding IPAs
# project_dir = os.path.dirname(os.path.realpath('__file__')) #Finds the project's directory
# #print(file_dir)

# file_dir = os.path.join(project_dir, 'QuizPython\\test.json') #Grabs the file from the projects directory as a reference
# #print(file_name)

# with open(file_dir, "r")as f:
#     data = json.load(f)

#Functions

def Get_List_Words_Practice() -> list: #Deprecated
    return ["destiny","defenestration","thou","coke","bass"]

#A function that randomly selects a word to be used for the problem and removes it from the roster
def Select_Word(word_list:list) -> str:
    random_num = random.randrange(0,len(word_list))
    selected_word = word_list[random_num]
    word_list.pop(random_num)

    return selected_word

#Grabs the IPA of the selected word via a database (can be from a JSON, equivalent, or an outsourced platform)
# Modified: Grabs the IPA of the selected word from the local word bank.
def Get_Word_IPA(selected_word) -> str:
    return wb.get_ipa(selected_word)

#Grabs the selected word's syllables via a database (can be from a JSON, equivalent, or an outsourced platform)
# Modified: Grabs the selected word's syllables from the local word bank.
def Get_Word_Syllables(selected_word:str) -> str:
    return wb.get_syllables(selected_word) or []

#Function where it generates wrong answers for the problem by randomizing each syllable position and characters
def Generate_Evil_Words(word:str) -> list:
    print(word)
    
    wrong_answers = [] #List where it carries the wrong answers after they've been horribly disfigured
    wrong_answers.append([word])

    #Primary loop, where the magic happens! Three times to generate 3 erroneous words
    for i in range(3):
        #print(i)
        word_temp = word[1:-1] #Copies the IPA_word into a temp variable in other to modify the IPA word without affecting the original one

        word_temp = list(word_temp)
        random.shuffle(word_temp)
        word_temp = "".join(word_temp)

        word_temp = word[0] + word_temp + word[-1]
        
        print(word_temp)
        wrong_answers.append([word_temp])
        print(wrong_answers)

    return wrong_answers

#------Start------
def main():
    #Sets up the initial values for the quiz
    #words = Words_for_Quiz() #Place where the user inputs the amount and which words they'd like to practice
    #Code from issue #90 (User input for quiz)
    num_quizes = 0 #Tracks how many quizes the user's taken
    num_incorrect = 0 #How many quizes the user got incorrect
    continue_quiz = True
    is_correct = True

    #print(Get_Random_English_Word())
    #print(Get_Random_Top_nth_Common_Word(1000))

    #The quiz will continue until all the words inputted are used
    while (continue_quiz):
        num_quizes += 1

        #Checks whether the answer is correct.
        #If true, it will go into the next word of the list.
        #If false, it will not go into the next word in the list, as it will continue asking the user the same word until it's correct
        if is_correct:
            word = Get_Random_English_Word()
        
        options = Generate_Evil_Words(word)
        #Shuffles the answers around
        random.shuffle(options)

        #Actual quiz stuff
        print("Select the correct pronunciation for " + word)
        print("1. " + options[0][0])
        print("2. " + options[1][0])
        print("3. " + options[2][0])
        print("4. " + options[3][0])

        TTS_Speak(options[0])
        TTS_Speak(options[1])
        TTS_Speak(options[2])
        TTS_Speak(options[3])

        #Prompts the user to select a valid answer
        while True:
            try:
                answer = int(input("Answer: ")) - 1
                if (-1 < answer) and (answer < 4):
                    break
                #If an answer is NOT valid, it will through an error to go into the except block
                else:
                    0/0 #PERFECT way to cause an error :P

            #The except block, tells the user their answer is invalid to regives them to retry 
            except:
                print("Please select a valid answer")
    
        #Checks if the user selected the correct answer
        #If the answer is correct, it praises the user and restarts the quiz with the next word
        #If the answer is incorrect, it gives the user feedback and restarts the quiz with the same word
   
        if options[answer][0] == word:
            print("Correct!")
            is_correct = True
        
            while True:
                user_answer = input("Continue? [y/n] ")

                if(user_answer == "n"):
                    continue_quiz = False
                    break

                elif(user_answer == "y"):
                    continue_quiz = True
                    break
                else:
                    print("Select a valid answer!")

        else:
            num_incorrect += 1
            print("Incorrect!")
            is_correct = False

        #This loop will continue until ALL words have been aswered correctly

    print("Number of Correct Answers: " + str(num_quizes-num_incorrect) + "/" + str(num_quizes))

#Note: The code can be modified to fit in UI and interactive elements later down the line.
#Note: This quiz only works if the user inputs: "destiny","defenestration","thou","coke", or "bass"
#This can changed in the future once a database or a word bank is properly implemented/added (which should contain, at least, English words with their IPAs)

main()












#| ||
#|| |_