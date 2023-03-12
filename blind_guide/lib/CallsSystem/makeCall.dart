import 'package:blind_guide/CallsSystem/CallPage.dart';
import 'package:blind_guide/CallsSystem/ContactPage.dart';
import 'package:flutter/material.dart';

class HomeCalling extends StatefulWidget {
  @override
  _HomeCallingState createState() => _HomeCallingState();
}

class _HomeCallingState extends State<HomeCalling> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    ContactsPage(),
    CallPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone),
              label: 'Call',
            ),
          ],
        ),

    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
