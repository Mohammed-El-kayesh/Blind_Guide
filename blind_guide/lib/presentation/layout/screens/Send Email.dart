import 'package:blind_guide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _recipientController =
      TextEditingController(text: "blind.guide.team@gmail.com");
  final _subjectController =
      TextEditingController(text: "Complaint or inquiry");
  final _bodyController = TextEditingController();

  void _sendEmail() async {
    final Email email = Email(
      recipients: [_recipientController.text],
      subject: _subjectController.text,
      body: _bodyController.text,
    );

    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  IconButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.keyboard_arrow_right,size: 30,),color: Colors.teal[600],),
                  Text("المساعدة",style: TextStyle(color: Colors.teal,fontSize: Dimensions.p22,fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(height: Dimensions.p40),
              Text('إلى:'),
              TextField(
                controller: _recipientController,
                decoration: InputDecoration(
                  hintText: 'أدخل البريد الإلكتروني',
                ),
              ),
              SizedBox(height: 16),
              Text('عنوان الرسالة:'),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: 'اختر موضوع الرسالة',
                ),
              ),
              SizedBox(height: 16),
              Text('المشكلة:'),
              Expanded(
                child: TextField(
                  controller: _bodyController,
                  decoration: InputDecoration(
                    hintText: 'قم بتوضيح مشكلتك، أو أدخل سؤالك؟',
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _sendEmail,
                  child: Text('إرسال'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
