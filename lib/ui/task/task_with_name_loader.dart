import 'package:habit_tracker/persistance/hive_data_store.dart';
import 'package:habit_tracker/ui/task/task_with_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/task.dart';
import '../models/task_state.dart';


class TaskWithNameLoader extends ConsumerWidget {
  const TaskWithNameLoader({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStore = ref.watch(dataStoreProvider);
    return ValueListenableBuilder(
      valueListenable: dataStore.taskStateListenable(task: task),
      builder: (context, Box<TaskState> box, _) {
        final taskState = dataStore.taskState(box, task: task);
        return TaskWithName(
          task: task,
          complete: taskState.completed,
          onCompleted: (completed) {
            ref
                .read(dataStoreProvider)
                .setTaskState(task: task, completed: completed,);
          },
        );
      },
    );
  }
}
