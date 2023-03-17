import 'package:blind_guide/CallsSystem/commands.dart';
import 'package:blind_guide/CallsSystem/speech.dart';
import 'package:blind_guide/bloc/emergencyCallCubit/emergency_CallStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';

class emergencyCallCubit extends Cubit<emergencyCallStates> {
  emergencyCallCubit() : super(emergencyCallInitialState());

  static emergencyCallCubit get(context) => BlocProvider.of(context);

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

  // Text To Speech
  FlutterTts flutterTts = FlutterTts();

  void speak(String text) async {
    await flutterTts.speak(text);
  }

//DB Functions
  Database? database;
  List<Map> contacts = [];

  void clearLists() {
    contacts.clear();
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
          emit(emergencyCallCreateDBState());
        }).catchError((error) {
          print('error when creating table : ${error.toString()}');
          emit(emergencyCallErrorDBState());
        });
      },
      onOpen: (database) {
        print('DB opened!');
        getDataFromDatabase(database).then((value) {
          clearLists();
          value.forEach((element) {
            contacts.add(element);
          });
          emit(emergencyCallLoadedContacts());
        });
      },
    ).then((value) {
      database = value;
      emit(emergencyCallOpenDBState());
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
            emit(emergencyCallInsertIntoDBSuccessfully());
          });
        }).catchError((error) {
          print('Error when inserting new raw ${error.toString()}');
          emit(emergencyCallInsertIntoDBError());
        });
      },
    );
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM contacts');
  }

  void updateData({
    required String status,
    required int id,
  }) {
    database?.rawUpdate('UPDATE contacts SET status = ? WHERE id = ?',
        [status, id]).then((value) {
      getDataFromDatabase(database).then((value) {
        clearLists();

        value.forEach((element) {
          contacts.add(element);
        });
      });
    });
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
        emit(emergencyCallDeleteFromDBSuccessfully());
      });
    });
  }



}
