
import 'package:blind_guide/presentation/layout/screens/emergencyCalls.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../presentation/layout/screens/colorDetection.dart';
import '../presentation/layout/screens/soundtest.dart';
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
    Constants.WelcomScreen_STR,
    Constants.objectDetection_STR,
    Constants.colorDetection_STR,
    Constants.textRecognition_STR,
    Constants.emergencyCalls_STR];
  final List<Widget> screensList =[
    const soundScreen(),
    ObjectDetectionScreen(),
    ColorDetectionScreen(),
    OCRScannerScreen(),
    EmergencyScreen(),
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

}