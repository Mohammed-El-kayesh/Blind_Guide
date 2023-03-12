import 'dart:async';
import 'dart:io';
import 'package:blind_guide/CallsSystem/Contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "contacts_database.db";
  static final _databaseVersion = 1;

  static final table = 'contacts';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnPhoneNumber = 'phoneNumber';

  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPhoneNumber TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Contact contact) async {
    Database db = await instance.database;
    return await db.insert(table, contact.toMap());
  }

  Future<List<Contact>> getAllContacts() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Contact(
        id: maps[i][columnId],
        name: maps[i][columnName],
        phoneNumber: maps[i][columnPhoneNumber],
      );
    });
  }

  Future<int> update(Contact contact) async {
    Database db = await instance.database;
    return await db.update(table, contact.toMap(),
        where: '$columnId = ?', whereArgs: [contact.id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
