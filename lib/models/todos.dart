import 'package:hive/hive.dart';
import 'package:note_it/models/todoitem.dart';

part 'todos.g.dart';

@HiveType(typeId: 1)
class Todos extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  List<TodoItem>? todo_items = [];

  @HiveField(3)
  String? tag;

  @HiveField(4)
  bool? is_archived = false;

  @HiveField(5)
  DateTime? created_at = DateTime.now();

  @HiveField(6)
  DateTime? updated_at = DateTime.now();
  // Hive fields go here
  Todos(
      {required this.id,
      this.title,
      this.todo_items,
      this.tag,
      this.is_archived,
      this.created_at,
      this.updated_at});
}

// class TodoItem {
//   String title;
//   bool is_done = false;

//   TodoItem(this.title, this.is_done);
// }
