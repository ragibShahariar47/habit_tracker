import 'package:flutter/material.dart';
import 'package:habit_tracker/constants/app_assets.dart';
import 'package:habit_tracker/ui/common_widgets/centered_svg_icon.dart';
import 'package:habit_tracker/ui/task/task_completion_ring.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/animations/animation_controller_state.dart';

class AnimatedTask extends StatefulWidget {
  const AnimatedTask({
    super.key,
    required this.taskIconName,
    required this.complete,
    this.onComplete,
  });
  final String taskIconName;
  final bool complete;
  final ValueChanged<bool>? onComplete;

  // ignore_for_file: no_logic_in_create_state
  @override
  AnimationControllerState<AnimatedTask> createState() =>
      _AnimatedTaskState(const Duration(milliseconds: 750));
}

class _AnimatedTaskState extends AnimationControllerState<AnimatedTask> {
  _AnimatedTaskState(super.duration);
  late final Animation<double> _curveAnimation;
  bool _showCheckIcon = false;
  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_checkStatusUpdates);
    _curveAnimation = animationController.drive(
      CurveTween(curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_checkStatusUpdates);
    super.dispose();
  }

  void _checkStatusUpdates(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onComplete?.call(true);
      if (mounted) {
        setState(() => _showCheckIcon = true);
      }
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _showCheckIcon = false);
        }
      });
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.complete &&
        animationController.status != AnimationStatus.completed) {
      animationController.forward();
    } else if (!_showCheckIcon) {
      widget.onComplete?.call(false);
      animationController.value = 0.0;
    }
  }

  void _handleTapCancel() {
    if (animationController.status != AnimationStatus.completed) {
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: (_) => _handleTapCancel(),
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _curveAnimation,
        builder: (BuildContext context, Widget? child) {
          final themeData = AppTheme.of(context);
          final progress = widget.complete ? 1.0 : _curveAnimation.value;
          final hasCompleted = progress == 1.0;
          final iconColor =
              hasCompleted ? themeData.accentNegative : themeData.taskIcon;
          return Stack(
            children: [
              TaskCompletionRing(
                progress: progress,
              ),
              Positioned.fill(
                child: CenteredSvgIcon(
                  iconName: hasCompleted && _showCheckIcon
                      ? AppAssets.check
                      : widget.taskIconName,
                  color: iconColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
