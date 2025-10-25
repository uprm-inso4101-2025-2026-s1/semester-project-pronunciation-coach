import json
import os
import random
from User_input_for_quiz import *
from Random_Word_Picker import *
from QuizPython.TTS import *
#import nltk
#nltk.download('cmudict')
#from nltk.corpus import cmudict

#Initializes
#cmu_dict = cmudict.dict()

#Finds the file where the dictionary is with all the English words with its corresponding IPAs
#project_dir = os.path.dirname(os.path.realpath('__file__')) #Finds the project's directory
#print(file_dir)

#file_dir = os.path.join(project_dir, 'QuizPython\\test.json') #Grabs the file from the projects directory as a reference
#print(file_name)

#with open(file_dir, "r")as f:
    #data = json.load(f)

#Functions

#def Get_List_Words_Practice() -> list: #Deprecated
    #return ["destiny","defenestration","thou","coke","bass"]

#A function that randomly selects a word to be used for the problem and removes it from the roster
#def Select_Word(word_list:list) -> str: #Deprecated
    #random_num = random.randrange(0,len(word_list))
    #selected_word = word_list[random_num]
    #word_list.pop(random_num)

    #return selected_word

#Grabs the IPA of the selected word via a database (can be from a JSON, equivalent, or an outsourced platform)
#def Get_Word_IPA(selected_word) -> str: #Deprecated
    #Currently it's programmed to grab the selected word's IPA from a JSON for testing.
    #This function can be modified to grab the IPA from a different source.
    #return data[selected_word]["IPA"]

#Grabs the selected word's syllables via a database (can be from a JSON, equivalent, or an outsourced platform)
#def Get_Word_Syllables(seletected_word:str) -> str: #Deprecated
    #Currently it's programmed to grab the selected word's syllables from a JSON for testing.
    #This function can be modified to grab the IPA from a different source.
    #return data[seletected_word]["Syllables"]

#Function where it generates wrong answers for the problem by randomizing each syllable position and characters
def Generate_Evil_Words(word:str) -> list:
    #print(word)
    
    wrong_answers = [] #List where it carries the wrong answers after they've been horribly disfigured
    wrong_answers.append([word])

    #Primary loop, where the magic happens! Three times to generate 3 erroneous words
    for i in range(3):
        #print(i)
        word_temp = word[1:-1] #Stores a version of the word without its first and last letters

        word_temp = list(word_temp) #The string is converted to a list for shuffling the letters around
        random.shuffle(word_temp) #Shuffle shuffle shuffle shuffle
        word_temp = "".join(word_temp) #The shuffled word is converted back to a string

        word_temp = word[0] + word_temp + word[-1] #The word is given its first and last letters
        
        #print(word_temp)
        wrong_answers.append([word_temp]) #Appends the word as a list with 1 element so that the TTS is able to read it
        #The TTS will read what's in here. If you want the TTS to say something, this is the code that gives it what to say
        #print(wrong_answers)

    return wrong_answers

#------Start------
def main():
    #Sets up the initial values for the quiz
    num_quizes = 0 #Tracks how many quizes the user's taken
    num_incorrect = 0 #How many quizes the user got incorrect
    continue_quiz = True #Used to check if the user wants to continue taking the quiz
    is_correct = True #Used to verify if the user selected the correct answer

    #The quiz will continue until the user explicitly confirms they do not wish to keep going
    while (continue_quiz):
        num_quizes += 1
        
        if is_correct: #Checks whether the answer is correct.
            #If true, it will load up the next word
            #If false, it will not load up the next word

            word = Get_Random_English_Word() #The name of the function says it -_-
        
        options = Generate_Evil_Words(word)
        random.shuffle(options)  #Shuffles the answers around

        #Actual quiz stuff
        print("Select the correct pronunciation for " + word)
        print("1. " + options[0][0])
        print("2. " + options[1][0])
        print("3. " + options[2][0])
        print("4. " + options[3][0])

        for i in range(4): #The Text to Speech reads out each option
            TTS_Speak(options[i])

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
#This can changed in the future once a database or a word bank is properly implemented/added (which should contain, at least, English words with their IPAs)

main()












#| ||
#|| |_