import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:note_it/models/events.dart';
import 'package:note_it/models/notes.dart';
import 'package:note_it/utils/utils.dart';

// ignore: must_be_immutable
class EventsEditPage extends StatefulWidget {
  late String id;

  EventsEditPage({super.key, required this.id});

  @override
  State<EventsEditPage> createState() => _EventsEditPageState();
}

class _EventsEditPageState extends State<EventsEditPage> {
  late final Box eventsBox;
  late TextEditingController titleCtrl;
  late TextEditingController descriptionCtrl;
  final dateCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final today = kToday;
  var selectedDate = kToday;

  @override
  void initState() {
    super.initState();
    eventsBox = Hive.box('events_box');
    // notesBox = Hive.box('notes_box');
    final event = eventsBox.get(widget.id);
    titleCtrl = TextEditingController(text: event.title);
    descriptionCtrl = TextEditingController(text: event.description);
    selectedDate = event.event_date;
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

  _updateEvent() {
    var event = eventsBox.get(widget.id);
    event.title = titleCtrl.text;
    event.event_date = selectedDate;
    event.description = descriptionCtrl.text;
    event.updated_at = DateTime.now();
    event.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit event"),
        actions: [
          IconButton(
              onPressed: () {
                eventsBox.delete(widget.id);
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
                content: Text('Empty event can\'t be updated!'),
              ),
            );
          } else {
            _updateEvent();
            // context.go('/');
          }
          Navigator.pop(context);
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
