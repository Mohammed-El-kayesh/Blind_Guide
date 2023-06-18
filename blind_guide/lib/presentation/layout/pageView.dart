import 'package:blind_guide/presentation/layout/screens/colorDetection.dart';
import 'package:blind_guide/presentation/layout/screens/emergencyCalls.dart';
import 'package:blind_guide/presentation/layout/screens/objectDetection.dart';
import 'package:blind_guide/presentation/layout/screens/textRecognition.dart';
import 'package:blind_guide/presentation/layout/screens/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';
import '../../utils/font.dart';


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

  final List<String> pageString = [
    Constants.objectDetection_STR,
    Constants.colorDetection_STR,
    Constants.textRecognition_STR,
  ];
  final List<Widget> screensList =[
    const WelcomeScreen(),
    const ObjectDetectionScreen(),
    ColorDetectionScreen(),
    const TextRecognitionScreen(),
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
        body: Container(
          child: Stack(
            children: [
              PageView(
                controller: pageController,
                onPageChanged: (int index){
                  changePageViewIndex(index);
                },
                children: screensList,),

                currentPageIndex==0 || currentPageIndex == screensList.length -1 ?
                 Container() :  Container(
                  margin: EdgeInsets.only(bottom: Dimensions.p30),
                  child: Align(child:
                  Container(
                    width: 86.w,
                    height: Dimensions.p45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.p10),
                      color:const Color(0xFFCFEEE7),
                    ),
                    child: Stack(
                      children: [
                       Container(
                         height: Dimensions.p40,
                         child:
                         Directionality(
                           textDirection: TextDirection.rtl,
                           child:Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children:
                             List.generate(3,
                                   (index) {
                             if( index+1==currentPageIndex)
                             return  Container(
                                 width: 28.w,
                                 height: Dimensions.p40,
                                 margin: EdgeInsets.only(top: Dimensions.p3),
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(Dimensions.p10),
                                   color:const Color(0xFF1A765F),
                                 ),
                                 child: Center(
                                   child: Text(
                                     titles[currentPageIndex]
                                     , style: SafeGoogleFont(
                                     'Segoe UI',
                                     fontSize: Dimensions.p13,
                                     fontWeight: FontWeight.w600,
                                     color: Color(0xffffffff),
                                   ),
                                   ),
                                 ),
                               );
                             return  Container(
                                 width: 28.w,
                                 child: Text(
                                   pageString[index]
                                   , style: SafeGoogleFont(
                                   'Segoe UI',
                                   fontSize: Dimensions.p13,
                                   fontWeight: FontWeight.w600,
                                   color: Color(0xff000000),

                                 ),
                                   //  textAlign: TextAlign.center,
                                 ),
                               );
                             }),
                           ),
                         ),

                       ),
                        // Container(color: Colors.red,width:100,height: 100,),
                      ],
                    ),
                  ),
                    alignment:Alignment.bottomCenter,
                  ),
                ),

            ],
          ),
        )
    );
  }

  }
