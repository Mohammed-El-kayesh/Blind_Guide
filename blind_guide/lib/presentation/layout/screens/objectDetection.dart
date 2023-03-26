import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';
import 'package:tflite/tflite.dart';
import '../../../bloc/objectDetectionCubit/objectDetectionState.dart';
import '../../../main.dart';
import '../../../utils/constants.dart';


class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({Key? key}) : super(key: key);

  @override
  State<ObjectDetectionScreen> createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {

  bool isWorking = false;
  String result = '';
  CameraController cameraController= CameraController(cameras![0], ResolutionPreset.max);
  CameraImage? imgCamera;
  FlutterTts flutterTts =FlutterTts();
  Future<void> playobject() async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(result);
  }

  initCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.max);
    cameraController!.initialize().then((value) {
      if (mounted) {
        setState(() {
          cameraController!.startImageStream((image) {
            if (!isWorking) {
              isWorking = true;
              imgCamera = image;
              runModelOnStreamFrames();
            }
          });
        });
      }

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
        result += element["label"] +
            " " +
            (element["confidence"] as double).toStringAsFixed(2) +
            "\n\n";
      }
      if(mounted) {
        setState(() {
          result;
        });
      }
      isWorking = false;
    }
  }

  Future<dynamic> loadModel() async {
    await Tflite.loadModel(
      model: Constants.objectDetectionModel_STR,
      labels:Constants.objectDetectionLable_STR,
    );
  }

  Future<void> playVoiceNote(text) async {
    await flutterTts.setLanguage('ar-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);

    print("playVoiceNote");
  }
  @override
  void initState() {
    loadModel().then((value) => initCamera());
    super.initState();
  }
  @override
  void dispose()  {
    super.dispose();
    cameraController!.dispose();
    isWorking=false;
    Tflite.close();
    print("stopVoice***************************************");

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GestureDetector(
        onTap:(){
          playobject();
        } ,
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
                      child:
                      Container(
                        margin: EdgeInsets.only(top: Dimensions.p55),
                        child: SingleChildScrollView(
                          child: Text(
                            result??"",
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
