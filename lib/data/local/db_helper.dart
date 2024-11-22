import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  // Singleton Class - create single object
  DBHelper._();

  // create object
  static final DBHelper getInstance = DBHelper._();

  // table note
  static const String TABLE_NOTE = "note";
  static const String COLUMN_NOTE_SNO = "s_no";
  static const String COLUMN_NOTE_TITLE = "title";
  static const String COLUMN_NOTE_DESC = "desc";

  Database? myDB;

  // open db (path -> if exits then open else create)
  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "noteDB.db");
    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute("CREATE TABLE $TABLE_NOTE ("
          "$COLUMN_NOTE_SNO INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$COLUMN_NOTE_TITLE TEXT, "
          "$COLUMN_NOTE_DESC TEXT"
          ")");
    });
  }

  // All Queries
  // insertion
  Future<bool> addNote({required String mTitle, required String mDesc}) async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESC: mDesc,
    });
    return rowsEffected > 0;
  }

  // reading all data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    // select * from note
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE);
    return mData;
  }
}