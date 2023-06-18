/*
import 'package:blind_guide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

class ColorDetectionScreen extends StatefulWidget {

  @override
  State<ColorDetectionScreen> createState() => _ColorDetectionScreenState();
}

class _ColorDetectionScreenState extends State<ColorDetectionScreen> {
  final FlutterTts flutterTts = FlutterTts();

  final AudioPlayer audioPlayer = AudioPlayer();

  final String text = 'هذه الصفحة للتعرف على الألوان';

  Future<void> playVoiceNote() async {
    await flutterTts.stop();
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }
  void initState() {
    super.initState();

    playVoiceNote();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.colorDetection_STR),
      ),
      body: Container(
        child: Center(child: Text('Color Detection')),

      ),
    );
  }
}
*/



import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';
import 'package:tflite/tflite.dart';
import '../../../main.dart';
import '../../../utils/constants.dart';


class ColorDetectionScreen extends StatefulWidget {
  const ColorDetectionScreen({Key? key}) : super(key: key);

  @override
  State<ColorDetectionScreen> createState() => _ColorDetectionScreenState();
}

class _ColorDetectionScreenState extends State<ColorDetectionScreen> {
  bool isWorking = false;
  String result = '';
  CameraController? cameraController;
  CameraImage? imgCamera;

/////sound////
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  final String text = 'هذه الصفحة للتعرف على الألوان';

  initCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.max);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController!.startImageStream((image) {
          if (!isWorking) {
            isWorking = true;
            imgCamera = image;
            runModelOnStreamFrames();
          }
        });
      });
    });
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
        result = element["label"] +" ";

      }
      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  Future<dynamic> loadModel() async {
    await Tflite.loadModel(
      model:Constants.colorDetection_STR,
      labels:Constants.colorDetectionLable_STR,
    );
  }
  /////Sound////
  Future<void> playVoiceNote() async {
    await flutterTts.setLanguage('ar');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);

  }

  Future<void> playobject() async {
    await flutterTts.setLanguage('ar');
    await flutterTts.setPitch(1);
    await flutterTts.speak(result);
  }

  @override
  void initState() {
    loadModel().then((value) => initCamera());
    playVoiceNote();
    // playobject();
    // _translate();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.colorDetection_STR),
      ),
      body: GestureDetector(
        onTap:playobject ,
        child: Container(
          color: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [

                    Center(
                      child: SizedBox(
                        height:100.h,
                        width: 100.w,

                        child: imgCamera == null
                            ?  Icon(Icons.photo_camera_front, color: Colors.lightGreenAccent, size: Dimensions.p40)
                            : AspectRatio(
                          aspectRatio: cameraController!.value.aspectRatio,
                          child: CameraPreview(cameraController!),

                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: Dimensions.p55),
                        child: SingleChildScrollView(
                          child: Text(
                            result,
                            style:  TextStyle(
                              backgroundColor: Colors.white,
                              fontSize: Dimensions.p25,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }
}


