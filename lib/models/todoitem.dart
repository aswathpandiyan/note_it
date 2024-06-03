import 'package:hive/hive.dart';

part 'todoitem.g.dart';

@HiveType(typeId: 2)
class TodoItem extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  bool is_done = false;

  TodoItem({required this.title, required this.is_done});
  // Hive fields go here
}
