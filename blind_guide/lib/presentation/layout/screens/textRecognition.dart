
import 'package:blind_guide/utils/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:sizer/sizer.dart';

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({Key? key}) : super(key: key);

  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  late final FlutterTts flutterTts = FlutterTts();
  late CameraController cameraController;
  late TextRecognizer recognizer;
  String? recognizedText;

  bool isCamInitialize = false;


  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    cameraController = CameraController(firstCamera, ResolutionPreset.high);
    await cameraController.initialize();
    setState(() {});
  }

  void changeIsCamInitialize(){
    isCamInitialize = true;
    setState(() {});
  }

  Future<void> scanText() async {
    final image = await cameraController.takePicture();
    final visionImage = GoogleVisionImage.fromFilePath(image.path);
    final visionText = await recognizer.processImage(visionImage);
    setState(() {
      recognizedText = visionText.text;
    });

    playVoiceNote();
    //  emit(ScanTextState());
  }

  Future<void> playVoiceNote() async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    flutterTts.speak(recognizedText!);
    // emit(PlayVoiceNote());
    print("playVoiceNote");
  }

  Future<void> playInitVoice() async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    flutterTts.speak(Constants.TextRecognitionInitialText_STR);
    // emit(PlayVoiceNote());
    print("playVoiceNote");
  }

  @override
  void initState() {
    super.initState();
      initializeCamera();
      recognizer = GoogleVision.instance.textRecognizer();
      playInitVoice();


  }
  @override
  void dispose() {

    ()async=>await flutterTts.stop();
    ()async=>await flutterTts.pause();
    cameraController.dispose();
    recognizer.close();
    isCamInitialize=false;
    print("stopVoice***************************************");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //     key: _scaffoldKey,
      body:  isCamInitialize ? GestureDetector(
        onTap: ()=> scanText(),
        child: Stack(
          children: <Widget>[
            Container(
              height: 100.h,
              child: CameraPreview( cameraController),
            ),
            // SizedBox(height: 16),
            // if( recognizedText == "")
            //   Center(
            //       child:
            //       Text( recognizedText!)
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
    );



  }
}

/*

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:just_audio/just_audio.dart';

class OCRScannerScreen extends StatefulWidget {
  const OCRScannerScreen({Key? key}) : super(key: key);

  @override
  _OCRScannerScreenState createState() => _OCRScannerScreenState();
}

class _OCRScannerScreenState extends State<OCRScannerScreen> {
  late CameraController _cameraController;
  late TextRecognizer _recognizer;
  String? _recognizedText;
/////sound////
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  final String text = 'هذه الصفحة لللتعرف على النصوص و قراءتها';

  final FlutterTts flutterTtsReadText = FlutterTts();
  final AudioPlayer audioPPlayerReadText = AudioPlayer();



  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _recognizer = GoogleVision.instance.textRecognizer();
    playVoiceNote();


  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _recognizer.close();
    _cameraController.dispose();


    super.dispose();
  }
  Future<void> playVoiceNote() async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }


  Future<void> playScanText() async {
    await flutterTtsReadText.setLanguage('ar');
    await flutterTtsReadText.setPitch(1);
    await flutterTtsReadText.speak(_recognizedText!);
  }

  Future<void> _scanText() async {
    final image = await _cameraController.takePicture();
    final visionImage = GoogleVisionImage.fromFilePath(image.path);
    final visionText = await _recognizer.processImage(visionImage);
    setState(() {
      _recognizedText = visionText.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return Scaffold(

      body: GestureDetector(
        onTap: (){_scanText();
        playScanText();
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: CameraPreview(_cameraController,child: Text('$_recognizedText')),
            ),


          ],
        ),
      ),
    );
  }
}
*/