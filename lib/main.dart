import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_it/models/events.dart';
import 'package:note_it/models/notes.dart';
import 'package:note_it/models/todoitem.dart';
import 'package:note_it/models/todos.dart';
// import 'package:note_it/pages/notes/notes_add_page.dart';
// import 'package:note_it/pages/notes/notes_edit_page.dart';
import 'package:note_it/pages/root_page.dart';

// final GoRouter _router = GoRouter(
//   routes: [
//     GoRoute(
//       path: "/",
//       builder: (context, state) => const RootPage(),
//     ),
//     GoRoute(
//       path: "/notes_add",
//       builder: (context, state) => const NotesAddPage(),
//     )
//   ],
//   errorBuilder: (context, state) => const ErrorScreen(),
// );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(TodosAdapter());
  Hive.registerAdapter(TodoItemAdapter());
  Hive.registerAdapter(EventsAdapter());
  await Hive.openBox('notes_box');
  await Hive.openBox('todos_box');
  await Hive.openBox('events_box');
  runApp(
    EasyDynamicThemeWidget(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note It',
      // routerConfig: router,
      routes: {
        '/': (context) => const RootPage(),
        // '/notes_add': (context) => const NotesAddPage(),
        // '/notes_edit': (context) => const NotesEditPage(),
      },
      initialRoute: '/',
      // home: const RootPage(),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      //   useMaterial3: true,
      // ),
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: EasyDynamicTheme.of(context).themeMode,
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
