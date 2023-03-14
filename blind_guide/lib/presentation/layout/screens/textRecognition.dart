
import 'package:blind_guide/bloc/textRecognitionCubit/textRecognitionCubit.dart';
import 'package:blind_guide/utils/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

import '../../../bloc/appCubit.dart';
import '../../../bloc/appState.dart';
import '../../../bloc/textRecognitionCubit/textRecognitionState.dart';

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({Key? key}) : super(key: key);

  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {

  @override
  void initState() {
  var cubit = BlocProvider.of<TextRecognitionCubit>(context);
    cubit.playVoiceNote(Constants.TextRecognitionInitialText_STR).whenComplete(() => cubit.initializeCamera());
 // await  BlocProvider.of<AppCubit>(context).playVoiceNote(cubit.recognizedText).whenComplete(() => cubit.recognizedText="");
    super.initState();
  }
  @override
  void dispose() {
    var cubit = BlocProvider.of<TextRecognitionCubit>(context);
     cubit.cameraController.dispose();
    cubit.recognizer.close();
    cubit.isCamInitialize=false;
    super.dispose();
  }
// final AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<TextRecognitionCubit>(context);
    return BlocBuilder<TextRecognitionCubit,TextRecognitionState>(builder: (context,state)=>
        Scaffold(
          body:  cubit.isCamInitialize ? GestureDetector(
            onTap: ()=> cubit.scanText(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 100.h,
                  child: CameraPreview( cubit.cameraController),
                ),
                // SizedBox(height: 16),
                // if( cubit.recognizedText == "")
                //   Center(
                //       child:
                //       Text( cubit.recognizedText!)
                //     //     : ElevatedButton(
                //     //   onPressed: _scanText,
                //     //   child: Text('Click on any where in Screen'),
                //     // ),
                //   ),
              ],
            ),
          ) : Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_camera_front, color: Colors.lightGreenAccent, size: Dimensions.p40),
              ],
            ),
          ),
        )
    );



  }
}
