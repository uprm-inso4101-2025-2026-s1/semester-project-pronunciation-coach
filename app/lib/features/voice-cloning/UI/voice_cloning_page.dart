import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
// import '../audio_service/audio_service.dart' as audio_service; // Removed, as it was not used
import '../../../../core/common/colors.dart';
import 'dart:io';

/// ===========================================================================
/// VOICE CLONING PAGE - REFERENCE AUDIO RECORDING
/// ===========================================================================
/// 
/// PURPOSE:
/// - Simple user interface that allows the user to record audio
/// - Recorded audio will be stored and used as reference audio for the OpenVoice model
/// - This will provide the user with customizable Text-to-Speech
/// 
/// KEY FEATURES:
/// - Text to read from
/// - Start/Stop Recording button
/// - Playback slider to listen to the recording
/// - Clone and Synthesize button for voice-cloning demo
/// 
/// ARCHITECTURE:
/// - Stateful widget for Voice-Cloning page
/// - Audio cloner and synthesizer
/// - Stateless widget for bullet points
/// - Custom record and playback buttons
/// - Slider to choose where to start or resume playback
/// - TTS demo using OpenVoice
/// ===========================================================================

class VoiceCloningScreen extends StatefulWidget {
  const VoiceCloningScreen({super.key});

  @override
  State<VoiceCloningScreen> createState() => _VoiceCloningPage();
}

class _VoiceCloningPage extends State<VoiceCloningScreen> {
  // For audio recorder
  final recorder = AudioRecorder();
  bool isRecording = false;
  String? recordedFile;
  String? synthesizedFile; 

  // For audio playback
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  Duration minimunDuration = const Duration(seconds: 10); // Changed to const for best practice
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // For TTS synthesizing
  bool isSynthesizing = false;
  bool failedSynth = false;



  final List<String> promptText = [
    "“The quick brown fox jumps over the lazy dog.”",
    "“Every morning I enjoy a warm cup of coffee before starting my daily routine.”",
    "“Please speak clearly so the system can capture the natural tone and rhythm of your voice.”"
    ];

  Future<void> _cloneAndSynthesize(String text) async{
   // Inline check for minimum duration
    final isTooShort = duration < minimunDuration;
   if (recordedFile == null || isTooShort){
    debugPrint("Error: No recorded file path found or recording is too short.");
    return;
   }

   setState(() {
    isSynthesizing = true;
    failedSynth = false;
    synthesizedFile = null; // Clear old synthesis result before new attempt
   });

   const String apiUrl = "http://localhost:5001/synthesize";
   
   var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
   request.fields["text"] = text;

   request.files.add(await http.MultipartFile.fromPath(
    'reference_audio',
    recordedFile!,
    filename: 'reference_audio.wav'
   ));

   debugPrint("Sending request to FastAPI...");
   try {
    var streamedResponse = await request.send();
    
    if (streamedResponse.statusCode == 200) {
     // Success! The response body is the synthesized WAV audio file.
     final synthesizedBytes = await streamedResponse.stream.toBytes();
     debugPrint("Synthesis successful! Received ${synthesizedBytes.length} bytes of audio.");

     // --- 5. Save and Play the Result ---
     final dir = await getApplicationSupportDirectory();
     final outputFilePath = '${dir.path}/voice_cloning_page/synthesized_output.wav';
     
     final File outputFile = File(outputFilePath);
     await outputFile.writeAsBytes(synthesizedBytes);

     debugPrint("Synthesized audio saved to: $outputFilePath");

     setState(() {
      isSynthesizing = false; // Stop the loading indicator
      synthesizedFile = outputFilePath; // Store the successful result path
     });

     // Play the synthesized audio for feedback. .
     await player.stop();
     await player.setSource(DeviceFileSource(outputFilePath));
     player.resume(); // Removed 'await' so the function finishes instantly

    } else {
     // API returned an error (e.g., 400 or 500)
     final responseBody = await streamedResponse.stream.bytesToString();
     
     setState(() {
      failedSynth = true;
      isSynthesizing = false;
      synthesizedFile = null;
     });

     debugPrint("API Error ${streamedResponse.statusCode}: $responseBody");
    }
   } catch (e) {
    
    setState(() {
     failedSynth = true;
     isSynthesizing = false;
     synthesizedFile = null;
    });

    debugPrint("Network or connection error: $e");
   }
  }

  Future<void> startRecording() async {
   // --- FIX 1: Stop Playback to prevent resource conflict and crashing ---
   await player.stop(); 
   // -------------------------------------------------------------------

   if (!await recorder.hasPermission()) {
    debugPrint("Permission denied");
    return;
   }

   debugPrint('Pressed record button');
   // final dir = await getApplicationDocumentsDirectory();
   // final filePath = '${dir.path}\reference_audio.wav';
   final dir = await getApplicationSupportDirectory();
  // Create a subdirectory for your reference audio to keep things tidy
   final voiceCloningDir = Directory('${dir.path}/voice_cloning_page');
   if (!await voiceCloningDir.exists()) {
    await voiceCloningDir.create(recursive: true);
   }
   final filePath = '${voiceCloningDir.path}/reference_audio.wav';
   
   // --- UPDATE 2: Clear synthesized file when starting a new recording ---
   setState(() {
    synthesizedFile = null;
    // Also ensure isPlaying is false since we called player.stop()
    isPlaying = false;
      duration = Duration.zero; // Reset duration for new recording
   });

   await recorder.start(
    const RecordConfig(
     encoder: AudioEncoder.wav,
     bitRate: 128000,
     sampleRate: 44100,
     noiseSuppress: true
    ), 
    path: filePath);

   setState(() {
    isRecording = true;
    recordedFile = filePath;
   });
   
  }

  Future<void> stopRecording() async {
   final path = await recorder.stop();
   
   debugPrint('pressed stop recording');
   setState(() {
    isRecording = false;
    recordedFile = path;
   });
    
    // Load the recorded file immediately to trigger the duration update listener
    if (path != null) {
        await player.setSource(DeviceFileSource(path));
        await player.stop();
    }

   debugPrint("Saved recording at: $path"); 

  }

  // --- MODIFIED: Implement clean up on dispose ---
  @override
  void dispose() {
   player.dispose();
   recorder.dispose();
   
   // Clean up temporary files when the screen is closed
   // We intentionally do NOT clean up the recordedFile to preserve it as a resource.
   _cleanupFiles(synthesizedFile);

   super.dispose();
  }

  void _cleanupFiles(String? filePath) {
   if (filePath != null) {
    final file = File(filePath);
    if (file.existsSync()) {
     try {
      file.deleteSync();
      debugPrint("Cleaned up file: $filePath");
     } catch (e) {
      debugPrint("Error cleaning up file $filePath: $e");
     }
    }
   }
  }

  // ---------------------------------------------

  @override
  void initState(){
   super.initState();

   // Listen for states: playing, paused, stopped
   player.onPlayerStateChanged.listen((state) {
    setState((){
     isPlaying = state == PlayerState.playing;
    });
   });

   // Update duration
   player.onDurationChanged.listen((newDuration) {
    setState(() {
     duration = newDuration;
    });
   });

   //Update position
   player.onPositionChanged.listen((newPosition) {
    setState(() {
     position = newPosition;
    });
   });
  }

  Future<void> togglePlayback() async {
  // --- MODIFIED: Use null-aware operator to prioritize synthesizedFile ---
  // If synthesizedFile is not null, use it. Otherwise, fall back to recordedFile.
  final fileToPlay = synthesizedFile ?? recordedFile;
  // ----------------------------------------------------------------------

  if (fileToPlay == null) {
   debugPrint("No audio file to play.");
   return;
  }

  if (isPlaying) {
   // Stop Playback
   await player.stop();
   setState(() {
    isPlaying = false;
   });
   debugPrint("Playback stopped.");
  } else {
   // Start Playback
   // Set the source to the local file path
   await player.setSource(DeviceFileSource(fileToPlay));
   await player.resume();
   
   setState(() {
    isPlaying = true;
   });
   debugPrint("Playback started: $fileToPlay");
   
   // Reset the state upon completion
   player.onPlayerComplete.listen((_) {
    setState(() {
     isPlaying = false;
    });
    debugPrint("Playback completed.");
   });
  }
}

  @override
  Widget build(BuildContext context) {
   // Calculate isTooShort inline using the available state variables
    final isTooShort = duration < minimunDuration;

   // Determine the text to show on the Play button
   String playButtonText;
   if (synthesizedFile != null) {
    playButtonText = isPlaying ? "Pause Generated Audio" : "Play Generated Audio";
   } else {
    playButtonText = isPlaying ? "Pause Recording" : "Play Recording";
   }


   return Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
     title: const Text(
      'Record Your Voice!',
      style: TextStyle(fontWeight: FontWeight.w600),
     ),
     backgroundColor: isRecording ? Colors.red : Colors.blue,
     foregroundColor: AppColors.background,
     elevation: 0,
     automaticallyImplyLeading: false,
     leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.pop(context),
     ),
    ),
    body: Padding(
     padding: const EdgeInsets.all(16.0),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
           'Record your voice for customizable Text-to-Speech\nPlease read the following text aloud. Speak clearly and at a natural pace:',
           style: TextStyle (
            fontWeight: FontWeight.bold,
            fontSize: 24
           )

          ),
          // Duration Text
          Text(
           "Please make sure the audio is at least ${minimunDuration.inSeconds} seconds long. If not, the synthesizer won't run.",
           style: TextStyle(color: Colors.red, fontSize: 18, fontWeight:FontWeight.bold )
          ),

          Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            for(String s in promptText)
             Bullet(text: s,)
           ],
          ),

          const SizedBox(height: 30),

          // Recording button
          Center(
           child: ElevatedButton.icon(
            // Disable while synthesizing
            onPressed: isSynthesizing ? null : (isRecording ? stopRecording : startRecording),
            icon: Icon(isRecording ? Icons.stop : Icons.mic, color: AppColors.background),
            label: Text(
             isRecording ? "Stop Recording" : "Start Recording",
             style: TextStyle(color: AppColors.background)
            ),
            style: ElevatedButton.styleFrom(
             backgroundColor: isRecording ? Colors.red : Colors.blue,
             padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 16,
             ),
            ),
           ),
          ),

          const SizedBox(height: 20),

            // State-based Feedback and Playback Controls (Wrapped in a Card)
            if (recordedFile != null && !isRecording)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                       // --- Short Recording Warning (Using calculated status) ---
                      if (isTooShort && synthesizedFile == null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Center(
                            child: Text(
                              // Display current duration value from the notifier
                              '⚠️ Recording is too short (${duration.inSeconds}s). Please record for at least ${minimunDuration.inSeconds} seconds.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      if(failedSynth)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Center(
                            child: Text(
                              // Display current duration value from the notifier
                              '⚠️ Failed to Synthesize your voice. Please re-record your audio.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      // --- Synthesis Status Text and Instructions ---
                      Column(
                        children: [
                          Text(
                            synthesizedFile != null ? "Synthesis Complete!" : "Voice Cloning is now available!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: synthesizedFile != null ? Colors.green : Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          const SizedBox(height: 4),
                          Text(
                            synthesizedFile != null 
                              ? "Listen to your generated audio below. Start a new recording to clear this result."
                              : "Play back your recording! If you don't like the result, press the record button to re-record.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 18
                            )
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 10),

                      // --- Playback Slider ---
                      AnimatedSlide(
                        offset: duration.inSeconds > 0 ? Offset.zero : const Offset(0, 0.3),
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOut,
                        child: Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final pos = Duration(seconds: value.toInt());
                            await player.seek(pos);
                            await player.resume();
                            setState(() {
                              isPlaying = true;
                            });
                          },
                        ),
                      ),
                      
                      // --- Play/Pause Button ---
                      Builder(
                        builder: (context) {
                          return Center(
                            child: ElevatedButton.icon(
                              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: isPlaying ? AppColors.background : AppColors.primary),
                              label: Text(
                                playButtonText, 
                                style: TextStyle(color: isPlaying ? AppColors.background : AppColors.primary)
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isPlaying ? Colors.blue : AppColors.background,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                side: BorderSide(color: isPlaying ? Colors.transparent : AppColors.primary, width: 2), // Add border for contrast
                              ),
                              onPressed: togglePlayback,
                            )
                          );
                        }
                      ),
                      
                      const SizedBox(height: 30),

                      // --- Synthesis Button ---
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            // Disabled if synthesizing, if synthesis is complete, OR if recording is too short
                            backgroundColor: isSynthesizing || synthesizedFile != null || isTooShort ? Colors.grey : Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16,
                            ),
                          ),
                          // Disable while synthesizing OR if the demo exists OR if the recording is too short
                          onPressed: isSynthesizing || synthesizedFile != null || isTooShort
                              ? null 
                              : () async => _cloneAndSynthesize("Hello, this is a test of my cloned voice."),
                          icon: isSynthesizing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                // Show a spinning indicator instead of the icon
                                child: CircularProgressIndicator(
                                  color: AppColors.background,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(Icons.volume_up, color: AppColors.background),
                          
                          label: Text(
                            isSynthesizing 
                                ? "Cloning Voice..." 
                                : synthesizedFile != null ? "Generated (Rerun Synthesis)" : "Clone Voice and Synthesize Text",
                            style: TextStyle(color: AppColors.background)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      )
    );    
  }
}
class Bullet extends StatelessWidget {
  const Bullet({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("• "),
      Expanded(child: Text(text, style: TextStyle(fontSize: 20))),
      ],
    );  
  }
}