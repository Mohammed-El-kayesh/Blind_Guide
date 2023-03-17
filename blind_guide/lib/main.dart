import 'package:blind_guide/presentation/layout/screens/welcomeScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:blind_guide/presentation/layout/screens/noInternetScreen.dart';
import 'package:blind_guide/presentation/widgets/primaryText.dart';
import 'package:blind_guide/utils/colors.dart';
import 'package:blind_guide/utils/constants.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/appCubit.dart';
import 'bloc/objectDetectionCubit/objectDetectionCubit.dart';
import 'bloc/textRecognitionCubit/textRecognitionCubit.dart';
List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create:(context)=> AppCubit(),
        ),
        BlocProvider<TextRecognitionCubit>(
          create:(context)=> TextRecognitionCubit(),
        ),
        BlocProvider<ObjectDetectionCubit>(
          create:(context)=> ObjectDetectionCubit(),
        ),
      ],
      child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: Constants.appName,
                theme: ThemeData(primarySwatch: AppColors.mainColor),
                home: OfflineBuilder(
                  connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child,)
                  {
                    final bool connected = connectivity != ConnectivityResult.none;
                    if (connected) {
                      return   const WelcomeScreen();
                    } else {
                      return const NoInternetScreen();
                    }
                  },
                  child: Center(child: PrimaryText(text: Constants.checkInternetConnection_STR,),),
                )


            );
          }
      ),
    );
  }
}
