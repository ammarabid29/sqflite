import 'package:flutter/material.dart';
import 'package:sqflite_app/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      // view all nodes
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: Text('${allNotes[index][DBHelper.COLUMN_NOTE_SNO]}'),
                  title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                );
              },
            )
          : const Center(
              child: Text("No Notes yet!"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add notes
          bool check = await dbRef!
              .addNote(mTitle: 'New node', mDesc: "Do what you love");
          if (check) {
            getNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
