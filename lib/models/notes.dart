import 'package:hive/hive.dart';

part 'notes.g.dart';

@HiveType(typeId: 0)
class Notes extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? tag;
  @HiveField(4)
  bool? is_archived = false;
  @HiveField(5)
  DateTime? created_at = DateTime.now();
  @HiveField(6)
  DateTime? updated_at = DateTime.now();

  Notes(
      {required this.id,
      this.title,
      this.description,
      this.tag,
      this.is_archived,
      this.created_at,
      this.updated_at});

  // Hive fields go here
}
