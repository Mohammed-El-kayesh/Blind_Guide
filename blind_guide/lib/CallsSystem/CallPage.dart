import 'package:blind_guide/CallsSystem/Contact.dart';
import 'package:blind_guide/CallsSystem/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallPage extends StatefulWidget {
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late List<Contact> _contacts;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() async {
    List<Contact> contacts = await DatabaseHelper.instance.getAllContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  void _callContact(Contact contact) async {
    String url = 'tel:${contact.phoneNumber}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          Contact contact = _contacts[index];
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.phoneNumber),
            trailing: IconButton(
              icon: Icon(Icons.call),
              onPressed: () => _callContact(contact),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.pushNamed(context, '/addContact');
        },
      ),
    );
  }
}
