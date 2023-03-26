
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:just_audio/just_audio.dart';

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({Key? key}) : super(key: key);

  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
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
    _cameraController.dispose();
    _recognizer.close();
    super.dispose();
  }
  Future<void> playVoiceNote() async {
    await flutterTts.setLanguage('ar');
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
              child: CameraPreview(_cameraController,
                  // child: Text('$_recognizedText')
              ),
            ),


          ],
        ),
      ),
    );
  }
}
