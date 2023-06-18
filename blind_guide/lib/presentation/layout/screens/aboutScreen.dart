import 'package:blind_guide/utils/constants.dart';
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
      'الصفحة الأخيرة لاجراء المكالمات لطلب المساعدة حيث يقوم مساعد المكفوف باضافة خمس جهات اتصال فقط الى الصفحة ليستخدمها الشخص المكفوف \n'
      'بمجرد الضغط على الشاشة فيي اي صفحة يتم تنفيذ الوظيفة المحددة لها  \n'
      'يوجد صفحة لتسجيل المواعيد و التذكير بها بواسطة ارسال اشعار ف الوقت المحدد للموعد \n'
      'توجد صفحة لطرح الاسئلة و ارسال الشكاوي \n';



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
      body:
      SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.p10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.keyboard_arrow_right,size: 30,),color: Colors.teal[600],),
                  Text("عن التطبيق",style: TextStyle(color: Colors.teal,fontSize: Dimensions.p22,fontWeight: FontWeight.w700)),
                ],
              ),


              Text(text, textDirection: TextDirection.rtl,style: TextStyle(fontSize: Dimensions.p20),),
              SizedBox(
                height: 50,
              ),
          ElevatedButton.icon(
            onPressed: () {
              playVoiceNote(text);

            },
            icon: Icon(Icons.mic),
            label: Text('الاستماع للنص',style: TextStyle(fontSize: Dimensions.p20),),
          ),


            ],
          ),
        ),
      ),
    );
  }
}
