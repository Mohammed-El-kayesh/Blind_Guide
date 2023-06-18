import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:blind_guide/presentation/layout/pageView.dart';
import 'package:blind_guide/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../../model/onBoardingModel.dart';
import '../../share/sharedpreference.dart';
import '../../utils/colors.dart';
import '../../utils/font.dart';
import 'package:flutter_tts/flutter_tts.dart';


class OnBoarding extends StatefulWidget {
  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<OnBoarding_model> onBoarding = [
    OnBoarding_model(
        body: ' نحن هنا من اجلك !',
        title: 'اهلا بك فى مرشد المكفوفين',
        image: 'assets/images/blind-girl-sitting-and-reading-book.png'),
    OnBoarding_model (
        body: 'سيساعدك هذا التطبيق على اكتشاف والتعرف  \nعلى كل الاشياء حولك',
        title: 'شاهد كل شئ حولك',
        image: 'assets/images/three-quarter-view-of-blind-girl.png'),
    OnBoarding_model(
        body: ' باستخدام خاصية التعرف على النصوص ,  \n سيساعدك تطبييقنا على تحويل نصوص الكتب الى صوت ',
        title: 'اقرا كتبك المفضلة',
        image: 'assets/images/blind-girl-sitting-on-sofa-and-reading-book.png'),
    OnBoarding_model(
        body: 'احفظ عِدة ارقام للطوارئ ',
        title: 'نوفر مكالمات الطوارئ',
        image: 'assets/images/blind-girl-walking.png'),
  ];
  @override
  //bool islast = false;
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> playVoiceNote() async {
    await flutterTts.setLanguage('ar');
    await flutterTts.setPitch(1);
    await flutterTts.speak(onBoarding[index].title);

  }

  int index = 0;
  bool flag = true;
  CountDownController countDownController = CountDownController();

  void incIndex() {
    if (index < onBoarding.length) {
      index++;
      if (index == 2 && flag) {
        index = 1;
        flag = !flag;
      }
      if (index == 3 && !flag) {
        index = 2;
        flag = !flag;
      }
      countDownController.restart();
    }
    playVoiceNote();
  }

  void submit(context) async {
    // await CachHelper.setBoolData(
    //   key: Constants.isOnBoarding,
    //   value: true,
    // );
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
    //   return PageViewScreen();
    // }));
    // countDownController.restart();
  }

  @override
  void initState() {
    // countDownController.start();
    playVoiceNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // iphone14pro1Vwj (1:2)
          width: double.infinity,
          padding: EdgeInsets.only(top: Dimensions.p30),
          decoration: const BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(Dimensions.p20, Dimensions.p20,
                    Dimensions.p25, Dimensions.p25),
                child: Row(
                  children: [
                    Container(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: SafeGoogleFont(
                            'Oxygen',
                            fontSize: Dimensions.p25,
                            fontWeight: FontWeight.w400,
                            //     height: Dimensions.p22,
                            color: Color(0xff000000),
                          ),
                          children: [
                            TextSpan(
                              text: 'Blind',
                              style: SafeGoogleFont(
                                'Oxygen',
                                fontSize: Dimensions.p25,
                                fontWeight: FontWeight.w700,
                                //  height: Dimensions.p22,
                                color: Color(0xff19755f),
                              ),
                            ),
                            TextSpan(
                              text: 'Guide',
                              style: SafeGoogleFont(
                                'Oxygen',
                                fontSize: Dimensions.p25,
                                fontWeight: FontWeight.w400,
                                //       height: Dimensions.p22,
                                color: Color(0xff000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    CircularCountDownTimer(
                      duration: 5,
                      initialDuration: 0,
                      controller: countDownController,
                      width: Dimensions.p30,
                      height: Dimensions.p30,
                      ringColor: Colors.grey[300]!,
                      ringGradient: null,
                      fillColor: Color(0xff000000),
                      fillGradient: null,
                      backgroundColor: Color(0xff19755f),
                      backgroundGradient: null,
                      strokeWidth: Dimensions.p10,
                      strokeCap: StrokeCap.round,
                      textStyle: TextStyle(
                          fontSize: Dimensions.p12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textFormat: CountdownTextFormat.S,
                      isReverse: false,
                      isReverseAnimation: false,
                      isTimerTextShown: true,
                      autoStart: true,
                      onComplete: () {
                        if (index == onBoarding.length - 1) {
                          submit(context);
                        } else {
                          incIndex();
                          setState(() {});
                        }
                      },
                      // timeFormatterFunction:
                      //     (defaultFormatterFunction, duration) {
                      //   // if (duration.inSeconds == 0) {
                      //   return "${duration.inSeconds}";
                      //   // } else {
                      //   //     return Function.apply(defaultFormatterFunction, [duration]);
                      //   // }
                      //   // return Function.apply(defaultFormatterFunction, [duration]);
                      // },
                    ),
                  ],
                ),
              ),
              Container(
                // autogroup3ky1bpy (UqpHUgrEJvvwBNVX1k3KY1)
                padding: EdgeInsets.fromLTRB(
                    Dimensions.p30, Dimensions.p20, Dimensions.p30, 0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // blindgirlsittingandreadingbook (6:2036)
                      margin: EdgeInsets.fromLTRB(
                          Dimensions.p60, 0, 0, Dimensions.p65),
                      width: 220, // Dimensions.p220,
                      height: 320, //Dimensions.p320,
                      child: Image.asset(
                        onBoarding[index].image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      // welcometoblindguide7B3 (7:2041)
                      margin: EdgeInsets.fromLTRB(0, 0, 1, 6),
                      child: Text(
                        onBoarding[index].title,
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Segoe UI',
                                fontSize: Dimensions.p20,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff000000),
                              ),
                            ),
                    ),
                    Container(
                      // weareheretohelpyouinteractnorm (7:2042)
                      // margin: EdgeInsets.fromLTRB(0, 0, 0, 36),
                      height: Dimensions.p60,
                      child: Text(
                        onBoarding[index].body,
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Segoe UI',
                          fontSize: Dimensions.p16,
                          fontWeight: FontWeight.w300,
                          height: 1.375,
                          color: Color(0x84000000),
                        ),
                      ),
                    ),

                    ///indecator
                    Container(
                      // autogroupjmemTwB (UqpbbFW4Ypg7neKA1ejMEm)
                      margin: EdgeInsets.fromLTRB(
                          Dimensions.p80, 0, Dimensions.p80, Dimensions.p35),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(onBoarding.length, (i) {
                          return Row(
                            children: [
                              i == index
                                  ? Container(
                                      // rectangle2Tph (7:2049)
                                      width: Dimensions.p40,
                                      height: Dimensions.p8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.p10),
                                        color: Color(0xff73988f),
                                      ),
                                    )
                                  : Container(
                                      // rectangle3mBB (7:2050)
                                      width: Dimensions.p18,
                                      height: Dimensions.p8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.p10),
                                        color: Color(0xffd9d9d9),
                                      ),
                                    ),
                              SizedBox(
                                width: Dimensions.p10,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),

                    InkWell(
                      child: Container(
                        // autogroupuvj5FP3 (UqpHCryGPk3ESvtXcMuVJ5)
                        margin: EdgeInsets.fromLTRB(0, 0, 0, Dimensions.p35),
                        width: double.infinity,
                        height: Dimensions.p45,
                        decoration: BoxDecoration(
                          color: Color(0xff19755f),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            index == 0 ? 'Start' : "Next",
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Oxygen',
                              fontSize: Dimensions.p25,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.72,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (index == onBoarding.length - 1) {
                          submit(context);
                        } else {
                          incIndex();
                        }
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
