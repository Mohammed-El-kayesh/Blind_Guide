import 'package:blind_guide/presentation/layout/pageView.dart';
import 'package:blind_guide/presentation/layout/screens/welcomeScreen.dart';
import 'package:blind_guide/presentation/onBoarding/onboarding.dart';
import 'package:blind_guide/share/sharedpreference.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:blind_guide/presentation/layout/screens/noInternetScreen.dart';
import 'package:blind_guide/presentation/widgets/primaryText.dart';
import 'package:blind_guide/utils/colors.dart';
import 'package:blind_guide/utils/constants.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/appCubit.dart';
import 'bloc/blocObserver/blocObserver.dart';
import 'bloc/objectDetectionCubit/objectDetectionCubit.dart';
import 'bloc/textRecognitionCubit/textRecognitionCubit.dart';
List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachHelper.init();
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
