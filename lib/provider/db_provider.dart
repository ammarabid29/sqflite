import 'package:flutter/material.dart';
import 'package:sqflite_app/data/local/db_helper.dart';

class DbProvider extends ChangeNotifier {
  DBHelper dbHelper;
  DbProvider({required this.dbHelper});

  List<Map<String, dynamic>> _mData = [];

  // events
  // add notes
  void addNote(String title, String desc) async {
    bool check = await dbHelper.addNote(mTitle: title, mDesc: desc);
    if (check) {
      _mData = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }

  // update note
  void updateNote(String title, String desc, int sno) async {
    bool check =
        await dbHelper.updateNote(mTitle: title, mDesc: desc, sno: sno);
    if (check) {
      _mData = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }

  // delete note
  void deleteNote(int sno) async {
    bool check = await dbHelper.deleteNote(sno: sno);
    if (check) {
      _mData = await dbHelper.getAllNotes();
      notifyListeners();
    }
  }

  // show data
  List<Map<String, dynamic>> getNotes() => _mData;

  // show initially added data
  void getInitialNotes() async {
    _mData = await dbHelper.getAllNotes();
    notifyListeners();
  }
}
