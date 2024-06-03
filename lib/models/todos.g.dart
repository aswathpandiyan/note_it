// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodosAdapter extends TypeAdapter<Todos> {
  @override
  final int typeId = 1;

  @override
  Todos read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todos(
      id: fields[0] as String,
      title: fields[1] as String?,
      todo_items: (fields[2] as List?)?.cast<TodoItem>(),
      tag: fields[3] as String?,
      is_archived: fields[4] as bool?,
      created_at: fields[5] as DateTime?,
      updated_at: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Todos obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.todo_items)
      ..writeByte(3)
      ..write(obj.tag)
      ..writeByte(4)
      ..write(obj.is_archived)
      ..writeByte(5)
      ..write(obj.created_at)
      ..writeByte(6)
      ..write(obj.updated_at);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodosAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
