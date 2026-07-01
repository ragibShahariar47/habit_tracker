import 'package:flutter/services.dart';
import 'package:habit_tracker/ui/home/home_page_bottom_options.dart';
import 'package:habit_tracker/ui/home/task_grid.dart';
import 'package:habit_tracker/ui/models/app_theme_settings.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel_animator.dart';
import 'package:habit_tracker/ui/sliding_panel/theme_selection_close.dart';
import 'package:habit_tracker/ui/sliding_panel/theme_selection_list.dart';
import 'package:habit_tracker/ui/theming/animated_app_theme.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskGridPage extends StatelessWidget {
  const TaskGridPage({
    super.key,
    required this.tasks,
    required this.onFlip,
    required this.leftAnimatorKey,
    required this.rightAnimatorKey,
    required this.appThemeSettings,
    required this.onThemeColorIndexSelected,
    required this.onThemeVariantIndexSelected,
  });

  final List<Task> tasks;
  final VoidCallback onFlip;
  final GlobalKey<SlidingPanelAnimatorState> leftAnimatorKey;
  final GlobalKey<SlidingPanelAnimatorState> rightAnimatorKey;
  final AppThemeSettings appThemeSettings;
  final ValueChanged<int>? onThemeColorIndexSelected;
  final ValueChanged<int>? onThemeVariantIndexSelected;

  void enterEditMode() {
    rightAnimatorKey.currentState?.slideIn();
    leftAnimatorKey.currentState?.slideIn();
  }

  void exitEditMode() {
    rightAnimatorKey.currentState?.slideOut();
    leftAnimatorKey.currentState?.slideOut();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAppTheme(
      duration: Duration(milliseconds: 300),
      data: appThemeSettings.themeData,
      child: Builder(
        builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.of(context).overlayStyle,
          child: Scaffold(
            backgroundColor: AppTheme.of(context).primary,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRect(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 8.0,
                            ),
                            child: TaskGrid(tasks: tasks),
                          ),
                        ),
                        HomePageBottomOptions(
                          onFlip: onFlip,
                          onEnterEditMode: enterEditMode,
                        ),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      bottom: 10,
                      width: SlidingPanel.leftPanelFixedWidth,
                      child: SlidingPanelAnimator(
                        key: leftAnimatorKey,
                        direction: SlideDirection.leftToRight,
                        child: ThemeSelectionClose(onClose: exitEditMode),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 10,
                      width:
                          MediaQuery.of(context).size.width -
                          SlidingPanel.leftPanelFixedWidth,
                      child: SlidingPanelAnimator(
                        key: rightAnimatorKey,
                        direction: SlideDirection.rightToLeft,
                        child: ThemeSelectionList(
                          currentThemeSettings: appThemeSettings,
                          availableWidth:
                              MediaQuery.of(context).size.width -
                              SlidingPanel.leftPanelFixedWidth -
                              SlidingPanel.paddingWidth,
                          onColorIndexSelected: onThemeColorIndexSelected,
                          onVariantIndexSelected: onThemeVariantIndexSelected,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
