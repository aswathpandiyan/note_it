import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class NotesEditPage extends StatefulWidget {
  late String id;
  NotesEditPage({super.key, required this.id});

  @override
  State<NotesEditPage> createState() => _NotesEditPageState();
}

class _NotesEditPageState extends State<NotesEditPage> {
  late String description;
  late final Box notesBox;
  late TextEditingController titleCtrl;
  late TextEditingController descriptionCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box('notes_box');
    var note = notesBox.get(widget.id);
    titleCtrl = TextEditingController(text: note.title);
    descriptionCtrl = TextEditingController(text: note.description);
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  _updateNote() {
    var note = notesBox.get(widget.id);
    note.title = titleCtrl.text;
    note.description = descriptionCtrl.text;
    note.updated_at = DateTime.now();
    note.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit note"),
        actions: [
          IconButton(
              onPressed: () {
                notesBox.delete(widget.id);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
            // margin: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 2.0),
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleCtrl,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      // hintText: 'Enter Title',
                      hintText: 'Title',
                      hintStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: descriptionCtrl,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: InputBorder.none,
                      alignLabelWithHint: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: BorderSide.none,
                        // borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.green,
        // foregroundColor: Colors.white,
        onPressed: () {
          if (titleCtrl.text.isEmpty && descriptionCtrl.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Empty note can\'t be added!'),
              ),
            );
          } else {
            _updateNote();
          }
          Navigator.pop(context);
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
