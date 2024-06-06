import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_it/pages/events/events_add_page.dart';
import 'package:note_it/pages/events/events_edit_page.dart';
import 'package:note_it/utils/utils.dart';
import 'package:note_it/widgets/empty_widget.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  //late PackageInfo packageInfo = await PackageInfo.fromPlatform();

  late final Box eventsBox;

  List _selectedEvents = [];

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _onDateChange(DateTime? selecetdDay) {
    if (selecetdDay != null) {
      final filtered_events = eventsBox.values
          .where((evnt) => isSameDay(evnt.event_date, selecetdDay))
          .toList();
      // final filtered_events = _allEvents
      //     .where((event) => isSameDay(event.event_date, selecetdDay))
      //     .toList();
      print(filtered_events);
      setState(() {
        _selectedEvents = filtered_events;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventsBox = Hive.box('events_box');
    _selectedDay = _focusedDay;
    //_allEvents =
    _onDateChange(_selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: Column(children: [
        TableCalendar(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _onDateChange(_selectedDay);
              });

              print(_selectedDay);
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // Call `setState()` when updating calendar format
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
            // if (day.weekday == DateTime.thursday) {
            //   return [const Event('Cyclic event')];
            // }

            return [];
          },
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              if (day.weekday == DateTime.sunday) {
                final text = DateFormat.E().format(day);
                return Center(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
            },
          ),
        ),
        Expanded(
          key: UniqueKey(),
          child: Builder(builder: (context) {
            if (_selectedEvents.isEmpty) {
              return const EmptyWidget(message: "Events not found!");
            } else {
              return ListView.builder(
                itemCount: _selectedEvents.length,
                itemBuilder: (context, index) {
                  final event = _selectedEvents.elementAt(index);
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    // decoration: BoxDecoration(
                    //   border: Border.all(),
                    //   borderRadius: BorderRadius.circular(12.0),
                    // ),
                    child: Card.filled(
                      child: ListTile(
                        key: UniqueKey(),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EventsEditPage(
                              id: event.id as String,
                            );
                          })).then((res) => _onDateChange(_selectedDay));
                        },
                        title: Text(event.title),
                        subtitle: Text(event.description),
                      ),
                    ),
                  );
                },
              );
            }
          }),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const EventsAddPage();
          })).then((res) => _onDateChange(_selectedDay));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
