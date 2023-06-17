import 'package:blind_guide/presentation/layout/pageView.dart';
import 'package:blind_guide/presentation/onBoarding/onboarding.dart';
import 'package:blind_guide/share/sharedpreference.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:blind_guide/utils/colors.dart';
import 'package:blind_guide/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachHelper.init();
  await Firebase.initializeApp() ;

  cameras = await availableCameras();
  var  isOnBoarding= await CachHelper.getData(key:Constants.isOnBoarding );
  runApp( MyApp(isOnBoarding));

}

class MyApp extends StatelessWidget {

  var  isOnBoarding;
  MyApp(this.isOnBoarding) ;
  @override
  Widget build(BuildContext context) {
   // Dimensions.statusBarH=MediaQuery.of(context).padding.top;
    return  Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: Constants.appName,
                theme: ThemeData(primarySwatch: AppColors.mainColor),
                home: isOnBoarding==null? OnBoarding(): PageViewScreen(),
            );
          }
      );

  }
}
