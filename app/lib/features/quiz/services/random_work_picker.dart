import 'dart:math';
import 'package:english_words/english_words.dart';
import 'texttospeach.dart';

String Get_Random_Word(){
  var random_word = Random();
  var selected_word = all[random_word.nextInt(4000)];
  print(selected_word);
  //TTS_Speak(selected_word);
  //Get_List_of_Answers(selected_word);
  TTS_Speak_Answers(Get_List_of_Answers(selected_word));

  return selected_word.toLowerCase();
}
List<String> Get_List_of_Answers(String selected_word){
  List<String> options_words = [selected_word];
  List<String> selected_word_temp = [];
  List<String> vowels = ['a','e','i','o','u','y'];
  //List<String> consonant = ['q','w','r','t','y','p','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m'];
  final lakitu = Random();
  print(selected_word);
  for (var i = 0; i < 3; i++){
    //print(i);
    selected_word_temp = selected_word.split('');
    print(selected_word_temp);
    //print(selected_word_temp);
    for(var w = 0; w < selected_word.length; w++){
      print(w);
      for(String char in vowels){
        if (selected_word[w] == char){
          selected_word_temp[w] = vowels[lakitu.nextInt(vowels.length)];
          break;
        }
      }
    }

    options_words.add(selected_word_temp.join(''));
    print(options_words[i]);

  }
  print(options_words);
  return options_words;

}
