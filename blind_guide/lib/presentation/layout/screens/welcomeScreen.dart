import 'dart:async';

import 'package:blind_guide/presentation/widgets/primaryText.dart';
import 'package:blind_guide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../pageView.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  final String text = 'مرحبا بك في تطبيق مساعد المكفوفين';

  @override
  void initState(){
    super.initState();
    playVoiceNote().whenComplete(() =>Timer(const Duration(seconds: 3),()=> Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  PageViewScreen()))) ,);

  }

  Future<void> playVoiceNote() async {

    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);

    // final audioUrl = 'https://example.com/voice_note.mp3';
    // final audioSource = ProgressiveAudioSource(Uri.parse(audioUrl));
    // await audioPlayer.setAudioSource(audioSource);
    // await audioPlayer.play();
  }

  // @override
  // void dispose() {
  //   audioPlayer.stop();
  //   flutterTts.stop();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.p25),
        child: Center(
          child: Wrap(
            children: [
              PrimaryText(text:text),
            ],
          ),
          ),
      ),


    );
  }
}
