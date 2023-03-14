
import 'package:blind_guide/CallsSystem/makeCall.dart';
import 'package:blind_guide/presentation/layout/screens/emergencyCalls.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../presentation/layout/screens/colorDetection.dart';
import '../presentation/layout/screens/welcomeScreen.dart';
import '../presentation/layout/screens/objectDetection.dart';
import '../presentation/layout/screens/textRecognition.dart';
import '../utils/constants.dart';
import 'appState.dart';

class AppCubit extends Cubit<AppState>
{
  AppCubit():super(InitialState());

  PageController ?pageController;
  int currentPageIndex = 0;
  final List<String> titles = [
    //Constants.WelcomScreen_STR,
    Constants.objectDetection_STR,
    Constants.colorDetection_STR,
    Constants.textRecognition_STR,
    Constants.emergencyCalls_STR,
    Constants.HomeCalling_STR
  ];

  final List<Widget> screensList =[
    //const WelcomeScreen(),
    const ObjectDetectionScreen(),
    ColorDetectionScreen(),
    const TextRecognitionScreen(),
    const EmergencyScreen(),
    HomeCalling(),
  ];


  void initPageView() {
    pageController = PageController(
      initialPage: currentPageIndex,
      keepPage: true,
    );
  emit(InitPageView());
  }

  void changePageViewIndex(int index) {
    currentPageIndex=index;
  emit(ChangePageViewIndex());
  }

  Future<void> playVoiceNote(text) async {
    final FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
    print("playVoiceNote");
  }
}