import 'package:blind_guide/presentation/layout/screens/colorDetection.dart';
import 'package:blind_guide/presentation/layout/screens/emergencyCalls.dart';
import 'package:blind_guide/presentation/layout/screens/objectDetection.dart';
import 'package:blind_guide/presentation/layout/screens/textRecognition.dart';
import 'package:blind_guide/presentation/layout/screens/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../utils/constants.dart';


class PageViewScreen extends StatefulWidget {

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {

  PageController ?pageController;
  int currentPageIndex = 0;
  final List<String> titles = [
    Constants.WelcomScreen_STR,
    Constants.objectDetection_STR,
    Constants.colorDetection_STR,
    Constants.textRecognition_STR,
    Constants.emergencyCalls_STR,
  ];

  final List<Widget> screensList =[
    const WelcomeScreen(),
    const ObjectDetectionScreen(),
    ColorDetectionScreen(),
    const TextRecognitionScreen(),
    // OCRScannerScreen(),
    EmergencyScreen(),
  ];


  void initPageView() {
    pageController = PageController(
      initialPage: currentPageIndex,
      keepPage: true,
    );

  }
 @override
  void initState() {
   initPageView();
    super.initState();
  }
  void changePageViewIndex(int index) {

  setState(() {
    currentPageIndex=index;
  });
  }

  Future<void> playVoiceNote(text) async {
    final FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
    print("playVoiceNote");
  }

  // @override
  // void dispose() {
  //   _pageController!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titles[currentPageIndex]),
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (int index){
            changePageViewIndex(index);
          },
          children: screensList,)
    );
  }

  }
