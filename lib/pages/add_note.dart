import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_app/provider/db_provider.dart';

class AddNotePage extends StatelessWidget {
  const AddNotePage({
    this.isUpdate = false,
    this.sno = 0,
    this.title = '',
    this.desc = '',
    super.key,
  });

  final bool isUpdate;
  final String title;
  final String desc;
  final int sno;

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();

    if (isUpdate) {
      titleController.text = title;
      descController.text = desc;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? 'Update Note' : 'Add Note',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                      if (title.isNotEmpty && desc.isNotEmpty) {
                        if (isUpdate) {
                          context
                              .read<DbProvider>()
                              .updateNote(title, desc, sno);
                        } else {
                          context.read<DbProvider>().addNote(title, desc);
                        }
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill the required blanks"),
                          ),
                        );
                      }
                      titleController.clear();
                      descController.clear();
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
      ),
    );
  }
}
