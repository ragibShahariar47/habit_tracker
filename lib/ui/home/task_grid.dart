import 'dart:math';
import 'package:habit_tracker/ui/task/task_with_name_loader.dart';
import 'package:flutter/material.dart';

import 'package:habit_tracker/ui/models/task.dart';

class TaskGrid extends StatefulWidget {
  const TaskGrid({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  State<TaskGrid> createState() => _TaskGridState();
}

class _TaskGridState extends State<TaskGrid> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisSpacing = constraints.maxWidth * .05;
        final taskWidth = (constraints.maxWidth - crossAxisSpacing) / 2.0;
        final aspectRatio = .64;
        final taskHeight = taskWidth / aspectRatio;
        final mainAxisSpacing = max((constraints.maxHeight - taskHeight * 3) / 2.0, .1);
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.tasks.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (BuildContext context, int index) {
            return TaskWithNameLoader(
                key: ValueKey(widget.tasks[index].id),
                task: widget.tasks[index]);
          },
        );
      },
    );
  }
}
