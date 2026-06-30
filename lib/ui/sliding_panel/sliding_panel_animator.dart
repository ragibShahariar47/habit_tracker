import 'package:habit_tracker/ui/animations/animation_controller_state.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel.dart';
import 'package:flutter/material.dart';

class SlidingPanelAnimator extends StatefulWidget {
  const SlidingPanelAnimator({
    super.key,
    required this.direction,
    required this.child,
  });

  final SlideDirection direction;
  final Widget child;

  @override
  SlidingPanelAnimatorState createState() => SlidingPanelAnimatorState();
}

class SlidingPanelAnimatorState
    extends AnimationControllerState<SlidingPanelAnimator> {
  SlidingPanelAnimatorState() : super(Duration(milliseconds: 200));

  late final _curvedAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: animationController, curve: Curves.easeInOutCirc),
  );

  void slideIn() {
    animationController.forward();
  }

  void slideOut() {
    animationController.reverse();
  }

  double getOffsetX({required double screenWidth, required double animation}) {
    final startOffset = widget.direction == SlideDirection.rightToLeft
        ? screenWidth - SlidingPanel.leftPanelFixedWidth
        : -SlidingPanel.leftPanelFixedWidth;
    return startOffset * (1.0 - animation);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curvedAnimation,
      builder: (animation, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final offsetX = getOffsetX(
          animation: _curvedAnimation.value,
          screenWidth: screenWidth,
        );

        return Transform.translate(offset: Offset(offsetX, 0), child: child);
      },
      child: SlidingPanel(direction: widget.direction, child: widget.child),
    );
  }
}