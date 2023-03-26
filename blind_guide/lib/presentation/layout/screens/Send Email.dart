import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _recipientController = TextEditingController(text: "blind.guide.team@gmail.com");
  final _subjectController = TextEditingController(text: "Complaint or inquiry");
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
      appBar: AppBar(title: Text("Help"),),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),


            Text('To:'),
            TextField(
              controller: _recipientController,
              decoration: InputDecoration(
                hintText: 'Enter email address',
              ),
            ),
            SizedBox(height: 16),
            Text('Subject:'),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'Enter email subject',
              ),
            ),
            SizedBox(height: 16),
            Text('Body:'),
            Expanded(
              child: TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  hintText: 'Write your problem or Ask question',
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _sendEmail,
                child: Text('Send Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
