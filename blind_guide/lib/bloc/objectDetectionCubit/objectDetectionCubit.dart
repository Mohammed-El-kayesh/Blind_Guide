
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tflite/tflite.dart';

import '../../main.dart';
import '../../utils/constants.dart';
import 'objectDetectionState.dart';

class ObjectDetectionCubit extends Cubit<ObjectDetectionState>
{
  ObjectDetectionCubit():super(InitialState());

  bool isWorking = false;
  String result = '';
  CameraController cameraController= CameraController(cameras![0], ResolutionPreset.max);
  CameraImage? imgCamera;
/////sound////
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();



  Future<void> playobject() async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(result);
  }
  initCamera(mounted) {
    cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          if (!mounted) {
            return;
          }
          if (!isWorking) {
            isWorking = true;
            imgCamera = image;
            runModelOnStreamFrames();
          }
        });

    });
    emit(InitCameraState());
  }

  runModelOnStreamFrames() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );
      result = '';
      for (var element in recognitions!) {
        result = element["label"];

      }
      isWorking = false;

    }
    emit(RunModelOnStreamFramesState());
  }

  Future<dynamic> loadModel() async {
    await Tflite.loadModel(
      model: Constants.objectDetectionModel_STR,
      labels:Constants.objectDetectionLable_STR,
    );
    emit(LoadModelState());
  }

  Future<void> playVoiceNote(text) async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);

    print("playVoiceNote");
  }





}