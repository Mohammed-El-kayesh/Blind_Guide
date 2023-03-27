import 'package:blind_guide/CallsSystem/commands.dart';
import 'package:blind_guide/CallsSystem/speech.dart';
import 'package:blind_guide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:sqflite/sqflite.dart';

Database? database;
List<Map> contacts = [];

class EmergencyScreen extends StatefulWidget {
  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  PhoneContact? _phoneContact;
  FlutterTts flutterTts = FlutterTts();

  Future<void> waitcomplete() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> screenTitle() async {
    await flutterTts.speak('شاشة مكالمات الطواري');
  }

  void speakContacts() {
    Future.delayed(const Duration(seconds: 3), () async {
      if (contacts.length > 0) {
        for (int i = 0; i < contacts.length; i++) {
          await flutterTts.setLanguage("en-US");
          await flutterTts.speak((i + 1).toString());
          await flutterTts.setLanguage("ar-EG");
          await flutterTts.speak(contacts[i]['name']);
        }
      }
    });
  }

  @override
  void initState() {
    waitcomplete();
    screenTitle();
    createDatabase();
    speakContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.emergencyCalls_STR),
        actions: [
          IconButton(
            onPressed: () async {
              if (contacts.length < 5) {
                final PhoneContact contact =
                    await FlutterContactPicker.pickPhoneContact();
                _phoneContact = contact;
                insertToDatabase(
                    name: _phoneContact!.fullName ?? '---',
                    number: _phoneContact!.phoneNumber!.number ?? '*/*/*/');
              } else {
                await flutterTts.speak(
                    'لقد وَصَلْتا للحدى الأقصى من جهات الاتصال، من فضلك احذف واحدة لإضافة جهت اتصال جديدة');
              }
            },
            icon: Icon(Icons.contacts),
          ),
        ],
      ),
      body: Column(
        children: [
          if (contacts.isNotEmpty)
            Expanded(
              child: InkWell(
                child: ListView.separated(
                    itemBuilder: (context, index) => buildContactList(
                          context,
                          name: contacts[index]['name'],
                          phoneNumber: contacts[index]['number'],
                          id: index + 1,
                          contactID: contacts[index]['id'],
                        ),
                    separatorBuilder: (context, index) => Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[300],
                        ),
                    itemCount: contacts.length),
                onLongPress: () => toggleRecording(context),
              ),
            ),
          if (contacts.isEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.amber[300],
              margin: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.error_outline,
                    size: 35,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'No Contacts Yet! Add Some To Call',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Voice Recognition
  String textSample = 'Click button to start recording';
  bool isListening = false;

  Future toggleRecording(context) =>
      Speech.toggleRecording(onResult: (String text) {
        textSample = text;
      }, onListening: (bool isListening) {
        this.isListening = isListening;
        if (!isListening) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            Utils.scanVoicedText(textSample, context);
          });
        }
      });

  void speak(String text) async {
    await flutterTts.speak(text);
  }

// 1. Create DB
  void createDatabase() {
    openDatabase(
      'contacts.db',
      version: 1,
      onCreate: (database, version) async {
        print('DB Created!');
        await database
            .execute(
                'CREATE TABLE contacts (id INTEGER PRIMARY KEY, name TEXT, number TEXT)')
            .then((value) {
          print('Table Created!');
        }).catchError((error) {
          print('error when creating table : ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('DB opened!');
        getDataFromDatabase(database).then((value) {
          clearLists();
          value.forEach((element) {
            contacts.add(element);
            setState(() {
            });
          });
        });
      },
    ).then((value) {
      database = value;
    });
  }

// 2. insert into DB
  insertToDatabase({
    required String name,
    required String number,
  }) async {
    await database?.transaction(
      (txn) async {
        await txn
            .rawInsert(
          'INSERT INTO contacts(name, number) VALUES("$name", "$number")',
        )
            .then((value) {
          print('${value} inserted Successfully');

          getDataFromDatabase(database).then((value) {
            clearLists();
            value.forEach((element) {
              contacts.add(element);
            });
            setState(() {});
          });
        }).catchError((error) {
          print('Error when inserting new raw ${error.toString()}');
        });
      },
    );
  }

  //Class to List
  Widget buildContactList(
    BuildContext context, {
    required int id,
    required String name,
    required String phoneNumber,
    required int contactID,
  }) {
    return InkWell(
      onTap: () async {
        await FlutterPhoneDirectCaller.callNumber(phoneNumber);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          child: Text(id.toString()),
        ),
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          phoneNumber,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              deleteData(id: contactID);
            });
          },
          icon: const Icon(
            Icons.delete_outline_outlined,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  //DB Functions

  void clearLists() {
    contacts.clear();
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM contacts');
  }

// 5. Delete From DB
  void deleteData({
    required int id,
  }) {
    database
        ?.rawDelete('DELETE FROM contacts WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database).then((value) {
        clearLists();
        print('deleted Successfully!');
        value.forEach((element) {
          contacts.add(element);
        });
        setState(() {});
      });
    });
  }
}
