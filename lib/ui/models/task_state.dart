
import 'package:hive_flutter/adapters.dart';
part 'task_state.g.dart';

@HiveType(typeId: 1)
class TaskState extends HiveObject{
  @HiveField(0)
  final String taskId;

  @HiveField(1)
  final bool completed;

  TaskState({required this.taskId, required this.completed});
}