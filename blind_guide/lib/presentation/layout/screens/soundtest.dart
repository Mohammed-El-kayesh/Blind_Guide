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

  @override
  void initState() {
    super.initState();
    playVoiceNote();
  }

  Future<void> playVoiceNote() async {
    final String text = 'Welcome to my app!';

    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);

    final audioUrl = 'https://example.com/voice_note.mp3';
    final audioSource = ProgressiveAudioSource(Uri.parse(audioUrl));
    await audioPlayer.setAudioSource(audioSource);
    await audioPlayer.play();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Text('Hello, welcome to my app!'),
      ),
    );
  }
}
