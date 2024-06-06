import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:note_it/models/todoitem.dart';
import 'package:note_it/models/todos.dart';

class TodosAddPage extends StatefulWidget {
  const TodosAddPage({super.key});

  @override
  State<TodosAddPage> createState() => _TodosAddPageState();
}

class _TodosAddPageState extends State<TodosAddPage> {
  late final Box todosBox;
  final List<TodoItem> todoItemList = [];
  final titleCtrl = TextEditingController(text: "");
  final todoItemCtrl = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    todosBox = Hive.box('todos_box');
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    todoItemCtrl.dispose();
    super.dispose();
  }

  void _createTodo() async {
    Todos newTodo = Todos(
        id: nanoid(),
        title: titleCtrl.text,
        todo_items: todoItemList,
        tag: null,
        is_archived: false,
        created_at: DateTime.now(),
        updated_at: DateTime.now());

    todosBox.put(newTodo.id, newTodo);
  }

  void _onTodoAdd(String value) {
    if (value.isEmpty) {
      return;
    }
    final TodoItem todoItem = TodoItem(title: value, is_done: false);
    setState(() {
      todoItemList.add(todoItem);
      todoItemCtrl.clear();
    });
  }

  void _onDeleteTodoItem(int index) {
    setState(() {
      todoItemList.removeAt(index);
    });
  }

  void _onTapTodoItem(int index) {
    setState(() {
      final item = todoItemList.elementAt(index);
      item.is_done = !item.is_done;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add todos"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
            // margin: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 2.0),
            alignment: Alignment.topLeft,
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
                  controller: todoItemCtrl,
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (value) {
                    _onTodoAdd(value);
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter todo',
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
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (todoItemList.isNotEmpty) {
                        final todoItem = todoItemList[index];
                        return Card.filled(
                          child: InkWell(
                            onTap: () {
                              _onTapTodoItem(index);
                            },
                            child: ListTile(
                              title: Text(todoItem.title),
                              leading: todoItem.is_done
                                  ? const Icon(Icons.check_circle)
                                  : const Icon(Icons.circle_outlined),
                              trailing: IconButton(
                                  onPressed: () {
                                    _onDeleteTodoItem(index);
                                  },
                                  icon: const Icon(Icons.close)),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                    itemCount: todoItemList.length,
                  ),
                )
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.green,
        // foregroundColor: Colors.white,
        onPressed: () {
          if (titleCtrl.text.isEmpty && todoItemList.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Empty todo can\'t be added!'),
              ),
            );
          } else {
            _createTodo();
            // context.go('/');
          }
          Navigator.pop(context, 'done');
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
