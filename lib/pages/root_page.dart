import 'package:flutter/material.dart';
import 'package:note_it/pages/notes/notes_page.dart';
import 'package:note_it/pages/todos/todos_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    NotesPage(),
    TodosPage(),
    Text('Events Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Settings Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(milliseconds: 2000),
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.notes),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt),
            label: 'Todos',
          ),
          NavigationDestination(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        //backgroundColor: Colors.blue,
        elevation: 10,
        //surfaceTintColor: Colors.lime,
        //height: 20,
        //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
