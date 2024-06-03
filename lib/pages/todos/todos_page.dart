import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_it/pages/notes/notes_edit_page.dart';
import 'package:note_it/pages/todos/todos_add_page.dart';
import 'package:note_it/widgets/empty_widget.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  late final Box todosBox;

  @override
  void initState() {
    super.initState();
    todosBox = Hive.box('todos_box');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todos",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          // margin: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 2.0),
          alignment: Alignment.topLeft,
          child: ValueListenableBuilder(
            valueListenable: todosBox.listenable(),
            builder: (context, todos, child) {
              if (todos.isEmpty) {
                return const EmptyWidget(message: "Todos not found!");
              } else {
                return ListView.builder(
                  itemCount: todosBox.length,
                  itemBuilder: (context, index) {
                    var todo = todos.getAt(index);
                    return Card.filled(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 8.0),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return NotesEditPage(
                          //     id: todo.id,
                          //   );
                          // }));
                        },
                        child: ListTile(
                          title: Text(
                            todo.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final todoItems = todo.todo_items;
                                  if (todoItems.isNotEmpty) {
                                    final todoItem = todoItems[index];
                                    return Card.outlined(
                                      child: ListTile(
                                        title: Text(todoItem.title),
                                        leading: todoItem.is_done
                                            ? const Icon(
                                                Icons.check_circle_outline)
                                            : const Icon(
                                                Icons.check_circle_rounded),
                                      ),
                                    );
                                  }
                                  return null;
                                },
                                itemCount: todo.todo_items.length,
                              ),
                              Text(
                                DateFormat.yMMMMd().format(todo.created_at),
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
            return const TodosAddPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
