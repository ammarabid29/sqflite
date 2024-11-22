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
  String errorMessage = 'Please fill in the required fields';

  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  void showNoteSheet({bool isUpdate = false, int sno = 0}) {
    if (!isUpdate) {
      titleController.clear();
      descController.clear();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: getBottomModelSheet(isUpdate: isUpdate, sno: sno),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                  trailing: SizedBox(
                    width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            titleController.text =
                                allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                            descController.text =
                                allNotes[index][DBHelper.COLUMN_NOTE_DESC];
                            showNoteSheet(
                              isUpdate: true,
                              sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                            );
                          },
                          child: const Icon(Icons.edit),
                        ),
                        InkWell(
                          onTap: () async {
                            bool check = await dbRef!.deleteNote(
                                sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                            if (check) {
                              getNotes();
                            }
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteSheet();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getBottomModelSheet({bool isUpdate = false, int sno = 0}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isUpdate ? 'Update Note' : 'Add Note',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Enter title here",
              labelText: 'Title*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter description here",
              labelText: 'Description*',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                      side: const BorderSide(
                        width: 4,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    var title = titleController.text.trim();
                    var desc = descController.text.trim();
                    if (title.isEmpty || desc.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage)),
                      );
                      return;
                    }
                    bool check = isUpdate
                        ? await dbRef!
                            .updateNote(mTitle: title, mDesc: desc, sno: sno)
                        : await dbRef!.addNote(mTitle: title, mDesc: desc);
                    if (check) {
                      getNotes();
                    }
                    Navigator.pop(context);
                  },
                  child: Text(isUpdate ? 'Update Note' : 'Add Note'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                      side: const BorderSide(
                        width: 4,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
