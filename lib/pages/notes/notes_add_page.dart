import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:note_it/models/notes.dart';

class NotesAddPage extends StatefulWidget {
  const NotesAddPage({super.key});

  @override
  State<NotesAddPage> createState() => _NotesAddPageState();
}

class _NotesAddPageState extends State<NotesAddPage> {
  late final Box notesBox;
  final titleCtrl = TextEditingController(text: "");
  final descriptionCtrl = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box('notes_box');
  }

  _createNote() {
    Notes newData = Notes(
        id: nanoid(),
        title: titleCtrl.text,
        description: descriptionCtrl.text,
        tag: null,
        created_at: DateTime.now(),
        updated_at: DateTime.now());
    notesBox.put(newData.id, newData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add note"),
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
                      hintText: 'Title',
                      hintStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                      // labelText: 'Title',
                      // labelStyle: const TextStyle(
                      // fontSize: 20, fontWeight: FontWeight.bold),
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
                    autofocus: true,
                  ),
                  TextFormField(
                    controller: descriptionCtrl,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      // labelText: 'Description',
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
            _createNote();
            // context.go('/');
          }
          Navigator.pop(context, 'done');
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
