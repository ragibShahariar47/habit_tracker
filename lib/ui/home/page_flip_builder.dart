import 'dart:math';

import 'package:flutter/material.dart';

class PageFlipBuilder extends StatefulWidget {
  const PageFlipBuilder({
    super.key,
    required this.frontBuilder,
    required this.backBuilder,
  });

  final WidgetBuilder frontBuilder;
  final WidgetBuilder backBuilder;

  @override
  State<PageFlipBuilder> createState() => PageFlipBuilderState();
}

class PageFlipBuilderState extends State<PageFlipBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
  );

  bool showFrontPage = true;

  @override
  void initState() {
    _animationController.addStatusListener(_updateListener);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController.removeStatusListener(_updateListener);
    super.dispose();
  }

  void _updateListener(AnimationStatus status) {
    setState(() {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        showFrontPage = !showFrontPage;
      }
    });
  }

  void onFlip() {
    if (showFrontPage) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPageFlipBuilder(
      listenable: _animationController,
      frontPageBuilder: widget.frontBuilder,
      backPageBuilder: widget.backBuilder,
      showFrontPage: showFrontPage,
    );
  }
}

class AnimatedPageFlipBuilder extends AnimatedWidget {
  const AnimatedPageFlipBuilder({
    required super.listenable,
    required this.frontPageBuilder,
    required this.backPageBuilder,
    required this.showFrontPage,
  });

  final WidgetBuilder frontPageBuilder;
  final WidgetBuilder backPageBuilder;
  final bool showFrontPage;

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final isAnimationFirstHalf = animation.value < 0.5;
    final child = isAnimationFirstHalf
        ? frontPageBuilder(context)
        : backPageBuilder(context);
    final rotationValue = animation.value * pi;
    final rotationAngle = animation.value > 0.5
        ? pi - rotationValue
        : rotationValue;
    var tilt = (animation.value - 0.5).abs() - .5;
    tilt *= isAnimationFirstHalf ? -.003 : .003;
    return Transform(
      transform: Matrix4.rotationY(rotationAngle)..setEntry(3, 0, tilt),
      child: child,
      alignment: Alignment.center,
    );
  }
}
