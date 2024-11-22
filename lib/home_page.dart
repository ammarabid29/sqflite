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

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

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
          showModalBottomSheet(
            context: context,
            builder: (context) {
              String errorMessage = 'Fill the required blanks';
              return Container(
                padding: const EdgeInsets.all(11),
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'Add node',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 21),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Enter title here",
                        label: const Text('Title*'),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                    const SizedBox(height: 21),
                    TextField(
                      controller: descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Enter description here",
                        label: const Text('Description*'),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    Row(
                      children: [
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
                            onPressed: () async {
                              var title = titleController.text;
                              var desc = descController.text;
                              if (title.isNotEmpty && desc.isNotEmpty) {
                                bool check = await dbRef!.addNote(
                                  mTitle: title,
                                  mDesc: desc,
                                );
                                if (check) {
                                  getNotes();
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMessage)),
                                );
                                setState(() {});
                              }
                              titleController.clear();
                              descController.clear();
                              Navigator.pop(context);
                            },
                            child: const Text("Add note"),
                          ),
                        ),
                        const SizedBox(width: 11),
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
                              titleController.clear();
                              descController.clear();
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
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
