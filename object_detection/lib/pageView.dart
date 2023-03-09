
import 'package:flutter/material.dart';
import 'package:object_detection/ColorDetection.dart';
import 'package:object_detection/EmergencyCalls.dart';
import 'package:object_detection/TextRecognition.dart';
import 'package:object_detection/object%20Detection.dart';

class PageViewScreen extends StatefulWidget {

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  PageController ?_pageController;
  int _currentPageIndex = 0;
  final List<String> _titles = ['Object detection', 'Color Detection', 'Text Recognition','Emergency Calls'];

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _currentPageIndex,
      keepPage: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentPageIndex]),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: <Widget>[
          ObjectDetectionScreen(),
          ColorDetectionScreen(),
          TextRecoScreen(),
          EmergencyScreen(),
        ],
      ),
    );
  }

  }
