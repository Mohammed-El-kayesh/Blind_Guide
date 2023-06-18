import 'dart:async';

import 'package:blind_guide/presentation/layout/screens/NotificationScreen.dart';
import 'package:blind_guide/presentation/layout/screens/Send%20Email.dart';
import 'package:blind_guide/presentation/layout/screens/aboutScreen.dart';
import 'package:blind_guide/presentation/widgets/primaryText.dart';
import 'package:blind_guide/utils/constants.dart';
import 'package:blind_guide/utils/font.dart';
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
bool isTtsStop = true;


class _WelcomeScreenState extends State<WelcomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isComplete = false;


  final String text = 'مرحبا بك في تطبيق مساعد المكفوفين';

  @override
  void initState() {
    super.initState();

    Future<void> playVoiceNote(double event) async {
      isComplete = true;
      await flutterTts.setLanguage('ar');
      await flutterTts.setPitch(1);

      if (event < 1) {
        isTtsStop = false;
        await flutterTts.speak("يوجد عائق على بعد اقل من متر  ").then((value) => isTtsStop = true);
      } else if (event > 1 && event < 2) {
        setState(() {
          isTtsStop = false;
        });
        await flutterTts.speak("يوجد عائق على بعد اثنان متر  ").then((value) async {
          await Future.delayed(Duration(seconds: 4)).then((value) => isTtsStop = true);

        });
      } else if (event > 2 && event < 3) {
          isTtsStop = false;
        await flutterTts.speak("يوجد عائق على بعد ثلاثة امتار  ").then((value) => isTtsStop = true);
      } else {
        setState(() {
          isTtsStop = false;
        });
        await flutterTts.speak("يوجد عائق على بعد أكثر من ثلاثة متر  ").then((value) => isTtsStop = true);
      }
      flutterTts.setCompletionHandler(() {
        isComplete = false;
        print("end------------------");
      });
    }

    FirebaseDatabase.instance.ref().child('data').onValue.listen((event) async {
      print(event.snapshot.value);

      DataSnapshot snapshot = event.snapshot;

      Map<dynamic, dynamic>? dataMap = snapshot.value as Map<dynamic, dynamic>?;
      print(dataMap!['distance']);

      if (!isComplete) {
        if (dataMap['distance'] != null) {
          await playVoiceNote((int.parse(dataMap['distance']) / 100));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu,color: Colors.black,size:30,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xff19755f),
        width: Dimensions.p270,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(border: BorderDirectional(bottom: BorderSide(width: 1,color: Colors.white,))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Blind Guide",style: TextStyle(color: Colors.white,fontSize: 18),),
                  SizedBox(width: Dimensions.p20),
                  Image.asset("assets/images/logo.png",width: 100),
                ],
              ),
            ),

            ListTile(
              title: Text(
                'اطرح سؤالاً',
                  style: SafeGoogleFont(
                    'Oxygen',
                    fontSize: Dimensions.p18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.72,
                    color: Color(0xffffffff),
                  ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Directionality(textDirection: TextDirection.rtl,child: EmailScreen()),
                  ),
                );
              },
              trailing:  Icon(Icons.arrow_back_ios_new,color: Colors.white,),
            ),
            ListTile(
              title: Text('من نحن ',style: SafeGoogleFont(
                'Oxygen',
                fontSize: Dimensions.p18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.72,
                color: Color(0xffffffff),
              ),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Directionality(textDirection: TextDirection.rtl,child: AboutUS()),
                  ),
                );
              },
              trailing:  Icon(Icons.arrow_back_ios_new,color: Colors.white,),
            ),
            ListTile(
              title: Text('الإشعارات ',style: SafeGoogleFont(
                'Oxygen',
                fontSize: Dimensions.p18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.72,
                color: Color(0xffffffff),
              ),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Directionality(textDirection: TextDirection.rtl,child: NotificationScreen()),
                  ),
                );
              },
              trailing:  Icon(Icons.arrow_back_ios_new,color: Colors.white,),

            )
          ],
        ),
      ),
      body: Column(
        children:
        [
          SizedBox(height: Dimensions.p50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Text(
                    'مرحباً بك',
                    style: SafeGoogleFont(
                      'Oxygen',
                      fontSize: Dimensions.p25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.72,
                      color: Color(0xff19755f),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      'ابدأ تجربتك الممتعة مع مرشدك الذكي',
                      style: SafeGoogleFont(
                        'Oxygen',
                        fontSize: Dimensions.p18,
                        letterSpacing: 0.72,
                        color: Color(0xff19755f),
                      ),
                    ),
                  ),
                ],
              ),
              Image(image: AssetImage("assets/images/main-logo.png"),width: 120,),
            ],
          ),
          SizedBox(height: Dimensions.p50,),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width-40,
            color: Colors.blueGrey,
          ),

          /// Sound Effect
          SizedBox(
            height: 150,
            child: Center(
              child: SoundWaveformWidget(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'يوجد عائق على بعد ',
                style: SafeGoogleFont(
                  'Oxygen',
                  fontSize: Dimensions.p20,
                  letterSpacing: 0.72,
                ),
              ),
              Text(
                '2 متر',
                style: SafeGoogleFont(
                  'Oxygen',
                  fontSize: Dimensions.p25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.72,
                  color: Color(0xff19755f),
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}



class SoundWaveformWidget extends StatefulWidget {
  final int count;
  final double minHeight;
  final double maxHeight;
  final int durationInMilliseconds;
  const SoundWaveformWidget({
    Key? key,
    this.count = 6,
    this.minHeight = 10,
    this.maxHeight = 30,
    this.durationInMilliseconds = 500,
  }) : super(key: key);
  @override
  State<SoundWaveformWidget> createState() => _SoundWaveformWidgetState();
}

class _SoundWaveformWidgetState extends State<SoundWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.durationInMilliseconds,
        ))
      ..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.count;
    final minHeight = widget.minHeight;
    final maxHeight = widget.maxHeight;
    return AnimatedBuilder(
      animation: controller,
      builder: (c, child) {
        double t = controller.value;
        int current =   isTtsStop ? -1 : (count * t).floor();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            count,
                (i) => AnimatedContainer(
              duration: Duration(
                  milliseconds: widget.durationInMilliseconds ~/ count),
              margin: i == (count - 1)
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(left: 5),
              height: i == current ? maxHeight : minHeight,
              width: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
        );
      },
    );
  }
}
