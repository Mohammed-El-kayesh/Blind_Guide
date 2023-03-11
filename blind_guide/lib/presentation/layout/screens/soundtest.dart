import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

class soundScreen extends StatefulWidget {
  const soundScreen({Key? key}) : super(key: key);

  @override
  _soundScreenState createState() => _soundScreenState();
}

class _soundScreenState extends State<soundScreen> {

  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  final String text = 'اهلا و مرحبا بك في تطبيق مساعد المكفوفين لاستخدام التطبيق كل ما عليك هو القيام بسحب الشاشة لليسار';

  @override
  void initState() {
    super.initState();
    playVoiceNote();
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

      body: Center(
        child: SingleChildScrollView(
           child: Text('$text'),

              ),
        ),


    );
  }
}
