// import 'package:blind_guide/bloc/objectDetectionCubit/objectDetectionCubit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tflite/tflite.dart';
//
// import '../../utils/constants.dart';
// import '../textRecognitionCubit/textRecognitionCubit.dart';
//
// class MyBlocObserver extends BlocObserver {
//   @override
//   void onCreate(BlocBase bloc,) async {
//     super.onCreate(bloc);
//     if(bloc is TextRecognitionCubit){
//     await bloc.initializeCamera();
//     await bloc.playInitVoice();
//
//     }else if(bloc is ObjectDetectionCubit){
//      await bloc.loadModel();
//      await bloc.initCamera();
//      await bloc.playVoiceNote(Constants.ObjectDetectionInitialText_STR);
//
//     }
//     print('onCreate -- ${bloc.runtimeType}');
//   }
//
//   @override
//   void onChange(BlocBase bloc, Change change) {
//     super.onChange(bloc, change);
//     print('onChange -- ${bloc.runtimeType}, $change');
//   }
//
//   @override
//   void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
//     print('onError -- ${bloc.runtimeType}, $error');
//     super.onError(bloc, error, stackTrace);
//   }
//
//   @override
//   void onClose(BlocBase bloc,) async {
//     super.onClose(bloc);
//     if(bloc is TextRecognitionCubit)
//    {
//      await bloc.flutterTts.stop();
//      await bloc.cameraController.dispose();
//      await bloc.recognizer.close();
//      bloc.isCamInitialize=false;
//      print("stopVoice***************************************");
//     }else if(bloc is ObjectDetectionCubit){
//       bloc.cameraController.dispose();
//       bloc.isWorking=false;
//      Tflite.close();
//     }
//   }
// }