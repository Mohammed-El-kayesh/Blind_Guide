import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

class AboutUS extends StatefulWidget {
  const AboutUS({Key? key}) : super(key: key);

  @override
  State<AboutUS> createState() => _AboutUSState();
}

class _AboutUSState extends State<AboutUS> {
  String text='\nهذا التطبيق مجهز لمساعدة الاشخاص ذو الاعاقة البصرية حيث يحتوي على عدة صفحات :'
      'الصفحة الاولى تقوم بالتعرف على الاشياء لتجنب العوائق\n'
      'الصفحة الثانية تتعرف على النصوص و تقرائها\n'
      'الصفحة الثالثة تتعرف على الالوان \n'
      'الصفحة الأخيرة لاجراء المكالمات لطلب المساعدة حيث يقوم مساعد المكقوق باضافة خمس جهات اتصال فقط الى الصفحة ليستخدمها الشخص المكفوف ';
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playVoiceNote(text) async {
    await flutterTts.setLanguage('ar');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);

    print("playVoiceNote");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us'),),
      body:
      Column(

        children: [

          Text(text, textDirection: TextDirection.rtl,),
          SizedBox(
            height: 50,
          ),
      ElevatedButton.icon(
        onPressed: () {
          playVoiceNote(text);

        },
        icon: Icon(Icons.mic),
        label: Text('Listen'),
      ),


        ],
      ),
    );
  }
}
