import 'package:blind_guide/bloc/emergencyCallCubit/emergency_CallCubit.dart';
import 'package:blind_guide/bloc/emergencyCallCubit/emergency_CallStates.dart';
import 'package:blind_guide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class EmergencyScreen extends StatefulWidget {
  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  PhoneContact? _phoneContact;
  FlutterTts flutterTts = FlutterTts();

  // Voice Initilize
  Future<void> playVoiceNote(text) async {
    await flutterTts.setLanguage('ar-EG');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    playVoiceNote(Constants.EmergencyCallInitialText_STR);
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      emergencyCallCubit()
        ..createDatabase(),
      child:
      BlocConsumer<emergencyCallCubit, emergencyCallStates>(listener: (context, state) async {
        emergencyCallCubit cubit = emergencyCallCubit.get(context);
        await flutterTts.awaitSpeakCompletion(true);
        if (state is emergencyCallOpenDBState) {
          await flutterTts.speak('شاشة مكالمات الطواري');
        }
        Future.delayed(const Duration(seconds: 3), () async {
          if (state is emergencyCallLoadedContacts && cubit.contacts.length != 0) {
            print(cubit.contacts.length);
            for (int i = 0; i < cubit.contacts.length; i++) {
              await flutterTts.setLanguage("en-US");
              await flutterTts.speak((i + 1).toString());
              await flutterTts.setLanguage("ar-EG");
              await flutterTts.speak(cubit.contacts[i]['name']);
            }
          }
        });
      }, builder: (context, state) {
        emergencyCallCubit cubit = emergencyCallCubit.get(context);
        return Scaffold(
          // appBar: AppBar(
          //   title: Text('Emergency Call'),
          //   elevation: 0,
          //   actions: [
          //     // IconButton(
          //     //   onPressed: () async {
          //     //     if (cubit.contacts.length < 5) {
          //     //       final PhoneContact contact =
          //     //       await FlutterContactPicker.pickPhoneContact();
          //     //       _phoneContact = contact;
          //     //       cubit.insertToDatabase(
          //     //           name: _phoneContact!.fullName ?? '---',
          //     //           number: _phoneContact!.phoneNumber!.number ?? '*/*/*/');
          //     //     } else {
          //     //       await flutterTts.speak(
          //     //           'لقد وَصَلْتا للحدى الأقصى من جهات الاتصال، من فضلك احذف واحدة لإضافة جهت اتصال جديدة');
          //     //     }
          //     //   },
          //     //   icon: Icon(Icons.contacts),
          //     // ),
          //   ],
          // ),
          body: Column(
            children: [
              if (cubit.contacts.isNotEmpty)
                Expanded(
                  child: InkWell(
                    child: ListView.separated(
                        itemBuilder: (context, index) =>
                            ItemContact(
                              name: cubit.contacts[index]['name'],
                              phoneNumber: cubit.contacts[index]['number'],
                              id: index + 1,
                              contactID: cubit.contacts[index]['id'],
                            ),
                        separatorBuilder: (context, index) =>
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 20,
                              ),
                              height: 1,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              color: Colors.grey[300],
                            ),
                        itemCount: cubit.contacts.length),
                    onLongPress: () => cubit.toggleRecording(context),
                  ),
                ),
              if (cubit.contacts.isEmpty)
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
          floatingActionButton: FloatingActionButton(  onPressed: () async {
            if (cubit.contacts.length < 5) {
              final PhoneContact contact =
              await FlutterContactPicker.pickPhoneContact();
              _phoneContact = contact;
              cubit.insertToDatabase(
                  name: _phoneContact!.fullName ?? '---',
                  number: _phoneContact!.phoneNumber!.number ?? '*/*/*/');
            } else {
              await flutterTts.speak(
                  'لقد وَصَلْتا للحدى الأقصى من جهات الاتصال، من فضلك احذف واحدة لإضافة جهت اتصال جديدة');
            }
          },
            child: Icon(Icons.contacts),),
        );
      }),
    );
  }
}

class ItemContact extends StatelessWidget {
  final int id;
  final String name;
  final String phoneNumber;
  final int contactID;

  const ItemContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.contactID,
  });

  @override
  Widget build(BuildContext context) {
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
            emergencyCallCubit.get(context).deleteData(id: contactID);
          },
          icon: const Icon(
            Icons.delete_outline_outlined,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
