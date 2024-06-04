import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_it/models/todoitem.dart';

// ignore: must_be_immutable
class TodosEditPage extends StatefulWidget {
  late String id;
  TodosEditPage({super.key, required this.id});

  @override
  State<TodosEditPage> createState() => _TodosEditPageState();
}

class _TodosEditPageState extends State<TodosEditPage> {
  late final Box todosBox;
  late List<TodoItem> todoItemList;
  late TextEditingController titleCtrl;
  late TextEditingController todoItemCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    todosBox = Hive.box('todos_box');
    var todo = todosBox.get(widget.id);
    titleCtrl = TextEditingController(text: todo.title);
    todoItemCtrl = TextEditingController(text: "");
    todoItemList = todo.todo_items;
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    todoItemCtrl.dispose();
    super.dispose();
  }

  void _updateTodo() {
    var todo = todosBox.get(widget.id);
    todo.title = titleCtrl.text;
    todo.todo_items = todoItemList;
    todo.updated_at = DateTime.now();
    todo.save();
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
        title: const Text("Edit todo"),
        actions: [
          IconButton(
              onPressed: () {
                todosBox.delete(widget.id);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete)),
        ],
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
                              leading: (todoItem.is_done == true)
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
            _updateTodo();
            // _createTodo();
            // context.go('/');
          }
          Navigator.pop(context, 'done');
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
