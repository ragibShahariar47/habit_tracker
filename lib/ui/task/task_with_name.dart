import 'package:habit_tracker/ui/task/animated_task.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart'; // ✅ ADDED import
import 'package:flutter/material.dart';

import '../../constants/text_styles.dart';
import '../models/task.dart';

class TaskWithName extends StatelessWidget {
  const TaskWithName({super.key, required this.task, required this.complete, this.onCompleted});

  final Task task;
  final bool complete;
  final ValueChanged<bool>? onCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AnimatedTask(taskIconName: task.taskIconName, complete: complete, onComplete: onCompleted,),
        ),
        SizedBox(height: 8.0,),
        Text(
          task.name.toUpperCase(),
          style: TextStyles.taskName.copyWith(
            color: AppTheme.of(context).settingsText, // ✅ CHANGED from Colors.white
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}