// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter_tts/flutter_tts_web.dart';
//
// class TxTtoSpeach extends StatefulWidget {
//
//   @override
//   State<TxTtoSpeach> createState() => _TxTtoSpeachState();
// }
//
// class _TxTtoSpeachState extends State<TxTtoSpeach> {
//   FlutterTts ftts = FlutterTts();
// //  TtsState ttsState = TtsState.stopped;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//           padding: EdgeInsets.all(20),
//           alignment: Alignment.center,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 child: Text("Text to Speech"),
//                 onPressed:() async {
//
//                   //your custom configuration
//                   await ftts.setLanguage("en-US");
//                   await ftts.setSpeechRate(0.5); //speed of speech
//                   await ftts.setVolume(1.0); //volume of speech
//                   await ftts.setPitch(1); //pitc of sound
//
//                   //play text to sp
//                   var result = await ftts.speak("Hello World, this is Flutter Campus.");
//                   if(result == 1){
//                     //speaking
//                     ftts.setStartHandler(() {
//                       setState(() {
//                         print("Playing");
//                       //  ttsState = TtsState.playing;
//                       });
//                     });
//
//                   }else{
//                     //not speaking
//                     ftts.setStartHandler(() {
//                       setState(() {
//                         print("stop");
//                        // ttsState = TtsState.stopped;
//                       });
//                     });
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//   }
// }
