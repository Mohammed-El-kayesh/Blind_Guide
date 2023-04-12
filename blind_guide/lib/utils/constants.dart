//import 'package:sizer/sizer.dart';
//import 'package:carousel_slider/carousel_slider.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//Icon( Icons.password_outlined, ),
import 'package:sizer/sizer.dart';


class Constants{
 static const String appName="Blind Guid";
 static const String isOnBoarding="onboarding";
 static const String noInternet='${baseAssetImage}no_internet.png';
 static const String baseAssetImage='assets/images/';

 static const String checkInternetConnection_STR='Please check internet connection ';
 static const String emergencyCalls_STR='Emergency Calls';
 static const String textRecognition_STR='Text Recognition';
 static const String colorDetection_STR='Color Detection';
 static const String objectDetection_STR='Object detection';
 static const String WelcomScreen_STR='Welcome';
 static const String objectDetectionModel_STR='assets/model.tflite';
 static const String objectDetectionLable_STR='assets/label.txt';

 static const String ObjectDetectionInitialText_STR = 'تعرف على نوع الأشياء و تجنب العوائق';
 static const String TextRecognitionInitialText_STR = 'اضغط على الشاشة لللتعرف على النص';
 static const String EmergencyCallInitialText_STR = 'شاشة مكالمات الطوارئ';
}
class Dimensions{
 static double p5 = 100.h/(100.h/5);
 static double p8 = 100.h/(100.h/8);
 static double p10 = 100.h/(100.h/10);
 static double p12 = 100.h/(100.h/12);
 static double p13 = 100.h/(100.h/13);
 static double p15 = 100.h/(100.h/15);
 static double p16 = 100.h/(100.h/16);
 static double p17 = 100.h/(100.h/17);
 static double p18 = 100.h/(100.h/18);
 static double p20 = 100.h/(100.h/20);
 static double p22 = 100.h/(100.h/22);
 static double p24 = 100.h/(100.h/24);
 static double p25 = 100.h/(100.h/25);
 static double p30 = 100.h/(100.h/30);
 static double p35 = 100.h/(100.h/35);
 static double p40 = 100.h/(100.h/40);
 static double p45 = 100.h/(100.h/45);
 static double p50 = 100.h/(100.h/50);
 static double p55 = 100.h/(100.h/55);
 static double p60 = 100.h/(100.h/60);
 static double p65 = 100.h/(100.h/65);
 static double p70 = 100.h/(100.h/70);
 static double p75 = 100.h/(100.h/75);
 static double p80 = 100.h/(100.h/80);
 static double p85 = 100.h/(100.h/85);
 static double p90 = 100.h/(100.h/90);
 static double p95 = 100.h/(100.h/95);
 static double p100 = 100.h/(100.h/100);
 static double p220 = 100.h/(100.h/220);
 static double p270 = 100.h/(100.h/270);
 static double p320 = 100.h/(100.h/320);
 static double p370 = 100.h/(100.h/370);
 static double statusBarH =0;
 // if(Dimensions.statusBarH==0)
 // Dimensions.statusBarH=MediaQuery.of(context).padding.top;
}
