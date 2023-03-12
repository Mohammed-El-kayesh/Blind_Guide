
import 'package:blind_guide/utils/constants.dart';
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
  bool isCamInitialize = false;
/////sound////
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  final String text = 'هذه الصفحة لللتعرف على النصوص و قراءتها';
  @override
  void initState() {
    super.initState();
    playVoiceNote();
    _initializeCamera();
    _recognizer = GoogleVision.instance.textRecognizer();



  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {
      isCamInitialize = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _recognizer.close();
    isCamInitialize = false;
    super.dispose();
  }

  Future<void> playVoiceNote() async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
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
    // if (!_cameraController.value.isInitialized) {
    //   isCamInitialize = false;
    //   return Container();
    // }
    return Scaffold(
      body: isCamInitialize ? GestureDetector(
        onTap: (){_scanText();},
        child: Column(
          children: <Widget>[
            Expanded(
              child: CameraPreview(_cameraController),
            ),
            SizedBox(height: 16),
            Center(
              child: _recognizedText != null
                  ? Text(_recognizedText!)
                  : ElevatedButton(
                onPressed: _scanText,
                child: Text('Click on any where in Screen'),
              ),
            ),
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
