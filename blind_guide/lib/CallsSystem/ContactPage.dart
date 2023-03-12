import 'package:blind_guide/CallsSystem/Contact.dart';
import 'package:blind_guide/CallsSystem/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;

  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  _getContacts() async {
    List<Contact> contacts = await dbHelper.getAllContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text;
      String phoneNumber = phoneNumberController.text;

      Contact newContact = Contact(name: name, phoneNumber: phoneNumber, id: 0);
      await dbHelper.insert(newContact);

      setState(() {
        _contacts.add(newContact);
        nameController.clear();
        phoneNumberController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Add Contact'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text(contact.phoneNumber),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await dbHelper.delete(contact.id);
                      setState(() {
                        _contacts.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
