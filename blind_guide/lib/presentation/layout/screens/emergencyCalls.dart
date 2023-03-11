import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  /////sound////
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  final String text = 'هذه الصفحة لمكالمات الطوارئ وطلب المساعدة من أحد الأصدقاء حيث تحتوي على 3 أشخاص'
      '  يمكنك الاتصال بهم من خلال الضغط أعلى الشاشة او في منتصف الشاشة او في اخر الشاشة و سيقوم التطبيق بنقلك مباشرة الى لوحة اتصال الهاتف ';

  Future<void> playVoiceNote() async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  void initState() {
    super.initState();

    playVoiceNote();
  }

  String ContactName1 = "محمد";
  String ContactName2 = "خالد";
  String ContactName3 = "عمرو";

  final FlutterTts flutterTtsforCall1 = FlutterTts();
  final AudioPlayer audioPlayerforCall1 = AudioPlayer();

  final FlutterTts flutterTtsforCall2 = FlutterTts();
  final AudioPlayer audioPlayerforCall2 = AudioPlayer();

  final FlutterTts flutterTtsforCall3 = FlutterTts();
  final AudioPlayer audioPlayerforCall = AudioPlayer();

  Future<void> playContactName1() async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(ContactName1);
  }

    Future<void> playContactName2() async {
      await flutterTts.setLanguage('ar-US');
      await flutterTts.setPitch(1);
      await flutterTts.speak(ContactName2);
    }

  Future<void> playContactName3() async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(ContactName3);
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
                    Expanded(
                      child: ElevatedButton(

                        onPressed: () async {
                          playContactName1();

                          const phoneNumber = '01015638555';
                          final url = 'tel:$phoneNumber';
                          final url2 = 'sms:$phoneNumber';

                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Text("اتصل ب"+'$ContactName1',
                          style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      ),

                    ),
              SizedBox(
                height: 40,
              ),
                  
              

              Expanded(
                child: ElevatedButton(

                  onPressed: () async {
                    playContactName2();
                    const phoneNumber = '01021204207';
                    final url = 'tel:$phoneNumber';

                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text("اتصل ب"+'$ContactName2',
                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    playContactName3();
                    const phoneNumber = '01010499747';
                    final url = 'tel:$phoneNumber';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text("اتصل ب"+'$ContactName3',
                  style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                ),
              ),
              SizedBox(
                height: 20,
              ),

          ],
      )



      );
    }
  }
