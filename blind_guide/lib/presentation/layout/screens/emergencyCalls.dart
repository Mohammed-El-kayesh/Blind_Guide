import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  /////sound////
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  final String text = 'هذه الصفحة لمكالمات الطوارئ وطلب المساعدة من احد الاصدقاء';
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
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Ask Help !!!"),
        ),
      ),
    );
  }
}
