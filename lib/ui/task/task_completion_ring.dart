import 'dart:math';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:flutter/material.dart';

class TaskCompletionRing extends StatefulWidget {
  const TaskCompletionRing({super.key, required this.progress});

  final double progress;

  @override
  State<TaskCompletionRing> createState() => _TaskCompletionRingState();
}

class _TaskCompletionRingState extends State<TaskCompletionRing> {
  @override
  Widget build(BuildContext context) {
    //final themeData = AppTheme.of(context);

    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(
        painter: RingPainter(
          taskCompletedColor: AppTheme.of(context).taskRing,
          taskNotCompletedColor:  AppTheme.of(context).taskIcon,
          progress: widget.progress,
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  const RingPainter({
    required this.taskCompletedColor,
    required this.taskNotCompletedColor,
    required this.progress,
  });

  final Color taskCompletedColor;
  final Color taskNotCompletedColor;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final notCompleted = progress < 1.0;
    double strokeWidth = size.width / 15;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = notCompleted ? (size.width - strokeWidth) / 2 : size.width / 2;

    if (notCompleted) {
      final backgroundPaint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..color = taskCompletedColor
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, radius, backgroundPaint);
    }

    final foregroundPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..color = notCompleted ? taskNotCompletedColor : taskCompletedColor // ✅ swapped
      ..style = notCompleted ? PaintingStyle.stroke : PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) => oldDelegate.progress != progress;
}
