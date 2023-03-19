import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sizer/sizer.dart';
import 'package:tflite/tflite.dart';
import '../../../bloc/objectDetectionCubit/objectDetectionCubit.dart';
import '../../../bloc/objectDetectionCubit/objectDetectionState.dart';
import '../../../utils/constants.dart';


class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({Key? key}) : super(key: key);

  @override
  State<ObjectDetectionScreen> createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {



  final String text = 'هذه الصفحة للتعرف على نوع الأشياء و تجنب العوائق';
  @override
  void initState() {
    var cubit = BlocProvider.of<ObjectDetectionCubit>(context);
    cubit.loadModel().then((value) => cubit.initCamera(mounted));
    cubit.playVoiceNote(Constants.ObjectDetectionInitialText_STR);
    cubit.playVoiceNote(text);

    super.initState();
  }

  @override
  void dispose()  {
    BlocProvider.of<ObjectDetectionCubit>(context).cameraController.dispose();
    BlocProvider.of<ObjectDetectionCubit>(context).isWorking=false;
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ObjectDetectionCubit>(context);
    return BlocBuilder<ObjectDetectionCubit,ObjectDetectionState>(builder: (context,state)=>
        Scaffold(
          body: GestureDetector(
            onTap:(){
              cubit.playobject();
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

                            child: cubit.imgCamera == null
                                ?  Icon(Icons.photo_camera_front, color: Colors.lightGreenAccent, size: Dimensions.p40)
                                : AspectRatio(
                              aspectRatio: cubit.cameraController.value.aspectRatio,
                              child: CameraPreview(cubit.cameraController),

                            ),
                          ),
                        ),
                        Center(
                          child:
                        Container(
                              margin: EdgeInsets.only(top: Dimensions.p55),
                              child: SingleChildScrollView(
                                child: Text(
                                  cubit.result??"",
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

        )
    );

  }
}
