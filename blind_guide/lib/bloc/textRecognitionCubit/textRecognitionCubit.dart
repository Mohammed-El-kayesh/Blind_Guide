
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:just_audio/just_audio.dart';

import 'textRecognitionState.dart';

class TextRecognitionCubit extends Cubit<TextRecognitionState>
{
  TextRecognitionCubit():super(InitialState());
  final FlutterTts flutterTts = FlutterTts();
  late CameraController cameraController;
  final AudioPlayer audioPlayer = AudioPlayer();
  late TextRecognizer recognizer= GoogleVision.instance.textRecognizer();
  String? recognizedText="";
  bool isCamInitialize = false;

/////sound////


  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    cameraController = CameraController(firstCamera, ResolutionPreset.high);
    await cameraController.initialize();
    changeIsCamInitialize();
    print("initializeCamera");
   emit(InitializeCameraState());
  }

  void changeIsCamInitialize(){
   isCamInitialize = true;
   emit(ChangeIsCamInitializeState());
 }

  Future<void> scanText() async {
    final image = await cameraController.takePicture();
    final visionImage = GoogleVisionImage.fromFilePath(image.path);
    final visionText = await recognizer.processImage(visionImage);
    recognizedText = visionText.text;
    playVoiceNote(recognizedText);
    emit(ScanTextState());
  }

  Future<void> playVoiceNote(text) async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
    print("playVoiceNote");
  }





}