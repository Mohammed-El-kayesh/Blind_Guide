import 'dart:async';

import 'package:blind_guide/presentation/layout/screens/Send%20Email.dart';
import 'package:blind_guide/presentation/layout/screens/aboutScreen.dart';
import 'package:blind_guide/presentation/widgets/primaryText.dart';
import 'package:blind_guide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../main.dart';
import '../pageView.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isComplete = false ;
  final String text = 'مرحبا بك في تطبيق مساعد المكفوفين';
  @override
  void initState(){
    super.initState();

    Future<void> playVoiceNote(double event) async {
      isComplete = true ;
      await flutterTts.setLanguage('ar');
      await flutterTts.setPitch(1);

      if(event<1){
        await flutterTts.speak("يوجد عائق على بعد اقل من متر  ");
      }
      else if(event>1 &&event<2) {
        await flutterTts.speak("يوجد عائق على بعد اثنان متر  ");
      }
      else if(event >2 && event <3)
      {
        await flutterTts.speak("يوجد عائق على بعد ثلاثة امتار  ");
      }
      else
      {
        await flutterTts.speak("يوجد عائق على بعد أكثر من ثلاثة متر  ");

      }
      flutterTts.setCompletionHandler(() {
        isComplete = false ;
        print("end------------------") ;
      }) ;

    }
    FirebaseDatabase.instance.ref().child('data').onValue.listen((event) async {

      print(event.snapshot.value);

      DataSnapshot snapshot = event.snapshot;


      Map<dynamic, dynamic>? dataMap = snapshot.value as Map<dynamic, dynamic>? ;
      print(dataMap!['distance']);

      if(!isComplete) {
        if(dataMap['distance']!=null) {
          await playVoiceNote((int.parse(dataMap['distance'])/100)) ;
        }
      }
    });


  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(title: Text("Welcome"),),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text("Blind Guide"),),

            ///هنضيف لوجو المشروع////////////////

            ListTile(title: Text('Ask Question ?'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EmailScreen(),),);
            },),
            ListTile(title: Text('about Application '),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUS(),),);
              },)

          ],
        ),
      ),

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
