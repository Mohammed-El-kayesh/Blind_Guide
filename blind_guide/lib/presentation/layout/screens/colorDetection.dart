import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

class ColorDetectionScreen extends StatefulWidget {

  @override
  State<ColorDetectionScreen> createState() => _ColorDetectionScreenState();
}

class _ColorDetectionScreenState extends State<ColorDetectionScreen> {
  final FlutterTts flutterTts = FlutterTts();

  final AudioPlayer audioPlayer = AudioPlayer();

  final String text = 'هذه الصفحة للتعرف على الألوان';

  Future<void> playVoiceNote() async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }
  void initState() {
    super.initState();

    playVoiceNote();

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Color Detection')),

    );
  }
}
