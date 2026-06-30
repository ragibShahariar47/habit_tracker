import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';
part 'task.g.dart';

Uuid uuid = Uuid();

@HiveType(typeId: 0)
class Task {

  Task({
    required this.id,
    required this.name,
    required this.taskIconName,
  });

  factory Task.create({required String name, required String taskIconName}){
    return Task(id: uuid.v4(), name: name, taskIconName: taskIconName);
  }

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String taskIconName;
}