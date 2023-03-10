
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

class OCRScannerScreen extends StatefulWidget {
  const OCRScannerScreen({Key? key}) : super(key: key);

  @override
  _OCRScannerScreenState createState() => _OCRScannerScreenState();
}

class _OCRScannerScreenState extends State<OCRScannerScreen> {
  late CameraController _cameraController;
  late TextRecognizer _recognizer;
  String? _recognizedText;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _recognizer = GoogleVision.instance.textRecognizer();
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
      ),
    );
  }
}
