import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_app/data/local/db_helper.dart';
import 'package:sqflite_app/pages/add_note.dart';
import 'package:sqflite_app/pages/settings.dart';
import 'package:sqflite_app/provider/db_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<DbProvider>().getInitialNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) {
              return [
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 11),
                      Text('Settings')
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: Consumer<DbProvider>(
        builder: (ctx, provider, __) {
          List<Map<String, dynamic>> allNotes = provider.getNotes();

          return allNotes.isNotEmpty
              ? ListView.builder(
                  itemCount: allNotes.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      leading: Text('${index + 1}'),
                      title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                      subtitle:
                          Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                      trailing: SizedBox(
                        width: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => AddNotePage(
                                      isUpdate: true,
                                      title: allNotes[index]
                                          [DBHelper.COLUMN_NOTE_TITLE],
                                      desc: allNotes[index]
                                          [DBHelper.COLUMN_NOTE_DESC],
                                      sno: allNotes[index]
                                          [DBHelper.COLUMN_NOTE_SNO],
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(Icons.edit),
                            ),
                            InkWell(
                              onTap: () async {
                                // delete note
                                context.read<DbProvider>().deleteNote(
                                    allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("No Notes yet!"),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => AddNotePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
