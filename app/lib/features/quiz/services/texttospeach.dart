import 'package:text_to_speech/text_to_speech.dart';
import 'random_work_picker.dart';

TextToSpeech tts = TextToSpeech();
void TTS_Speak(selected_word) async{
    tts.speak(selected_word);
}
void TTS_Speak_Answers(answers) async{
    tts.speak(answers[0]);
    tts.speak(answers[1]);
    tts.speak(answers[2]);
    tts.speak(answers[3]);
}