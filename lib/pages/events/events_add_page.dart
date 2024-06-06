import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:note_it/models/events.dart';
import 'package:note_it/models/notes.dart';
import 'package:note_it/utils/utils.dart';

class EventsAddPage extends StatefulWidget {
  const EventsAddPage({super.key});

  @override
  State<EventsAddPage> createState() => _EventsAddPageState();
}

class _EventsAddPageState extends State<EventsAddPage> {
  late final Box eventsBox;
  final titleCtrl = TextEditingController(text: "");
  final descriptionCtrl = TextEditingController(text: "");
  final dateCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final today = kToday;
  var selectedDate = kToday;

  @override
  void initState() {
    super.initState();
    eventsBox = Hive.box('events_box');
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      helpText: 'Select event date', // Can be used as title
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  _createEvent() {
    // Events newData = Events(
    //     id: nanoid(),
    //     title: titleCtrl.text,
    //     description: descriptionCtrl.text,
    //     tag: null,
    //     event_date: dateCtrl.text,
    //     created_at: DateTime.now(),
    //     updated_at: DateTime.now());
    Events newData = Events(
        id: nanoid(),
        title: titleCtrl.text,
        description: descriptionCtrl.text,
        tag: null,
        event_date: selectedDate,
        created_at: DateTime.now(),
        updated_at: DateTime.now());
    eventsBox.put(newData.id, newData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add event"),
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
                    maxLines: 5,
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
                  TextButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.date_range),
                          const Padding(padding: EdgeInsets.all(3.0)),
                          Text(
                            DateFormat.yMMMMd().format(selectedDate),
                          ),
                        ],
                      ))
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
                content: Text('Empty event can\'t be added!'),
              ),
            );
          } else {
            _createEvent();
            // context.go('/');
          }
          Navigator.pop(context);
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
