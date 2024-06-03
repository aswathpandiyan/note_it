import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_it/pages/notes/notes_add_page.dart';
import 'package:note_it/pages/notes/notes_edit_page.dart';
import 'package:note_it/widgets/empty_widget.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final Box notesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box('notes_box');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          // margin: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 2.0),
          alignment: Alignment.topLeft,
          child: ValueListenableBuilder(
            valueListenable: notesBox.listenable(),
            builder: (context, notes, child) {
              if (notes.isEmpty) {
                return const EmptyWidget(message: "Notes not found!");
              } else {
                return ListView.builder(
                  itemCount: notesBox.length,
                  itemBuilder: (context, index) {
                    var note = notes.getAt(index);
                    return Card.filled(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 8.0),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return NotesEditPage(
                              id: note.id,
                            );
                          }));
                        },
                        child: ListTile(
                          title: Text(
                            note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                DateFormat.yMMMMd().format(note.created_at),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, '/notes_add');
          //context.go('/notes_add');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NotesAddPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
