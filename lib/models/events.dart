import 'package:hive/hive.dart';

part 'events.g.dart';

@HiveType(typeId: 3)
class Events extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime? event_date;

  @HiveField(4)
  String? tag;

  @HiveField(5)
  DateTime? created_at;

  @HiveField(6)
  DateTime? updated_at;

  Events(
      {required this.id,
      this.title,
      this.description,
      this.event_date,
      this.tag,
      this.created_at,
      this.updated_at});
  // Hive fields go here
}
