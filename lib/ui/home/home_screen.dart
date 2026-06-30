import 'package:habit_tracker/persistance/hive_data_store.dart';
import 'package:habit_tracker/ui/home/page_flip_builder.dart';
import 'package:habit_tracker/ui/home/task_grid_content.dart';
import 'package:habit_tracker/ui/sliding_panel/sliding_panel_animator.dart';
import 'package:habit_tracker/ui/theming/app_theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ CHANGED: ConsumerWidget → ConsumerStatefulWidget
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // ✅ MOVED: these used to be local `final` vars inside build(),
  // recreated on every rebuild. Now they're instance fields, created once.
  final pageFlipKey = GlobalKey<PageFlipBuilderState>();
  final _frontSlidingPanelLeftAnimatorKey =
  GlobalKey<SlidingPanelAnimatorState>();
  final _backSlidingPanelLeftAnimatorKey =
  GlobalKey<SlidingPanelAnimatorState>();
  final _frontSlidingPanelRightAnimatorKey =
  GlobalKey<SlidingPanelAnimatorState>();
  final _backSlidingPanelRightAnimatorKey =
  GlobalKey<SlidingPanelAnimatorState>();

  @override
  Widget build(BuildContext context) {
    final dataStore = ref.watch(dataStoreProvider);
    return ValueListenableBuilder(
      valueListenable: dataStore.frontTasksListenable(),
      builder: (_, box, _) {
        final tasks = box.values.toList();
        return PageFlipBuilder(
          key: pageFlipKey,
          frontBuilder: (_) => ValueListenableBuilder(
            valueListenable: dataStore.frontTasksListenable(),
            builder: (_, box, _) {
              return TaskGridPage(
                appThemeSettings: ref.watch(frontThemeSettingsProvider),
                onThemeColorIndexSelected: (index) => ref
                    .read(frontThemeSettingsProvider.notifier)
                    .updateColorIndex(index),
                onThemeVariantIndexSelected: (index) => ref
                    .read(frontThemeSettingsProvider.notifier)
                    .updateVariantIndex(index),
                tasks: box.values.toList(),
                onFlip: pageFlipKey.currentState!.onFlip,
                leftAnimatorKey: _frontSlidingPanelLeftAnimatorKey,
                rightAnimatorKey: _frontSlidingPanelRightAnimatorKey,
              );
            },
          ),
          backBuilder: (_) => ValueListenableBuilder(
            valueListenable: dataStore.backTasksListenable(),
            builder: (_, box, _) {
              return TaskGridPage(
                appThemeSettings: ref.watch(backThemeSettingsProvider),
                onThemeColorIndexSelected: (index) => ref
                    .read(backThemeSettingsProvider.notifier)
                    .updateColorIndex(index),
                onThemeVariantIndexSelected: (index) => ref
                    .read(backThemeSettingsProvider.notifier)
                    .updateVariantIndex(index),
                tasks: box.values.toList(),
                onFlip: pageFlipKey.currentState!.onFlip,
                leftAnimatorKey: _backSlidingPanelLeftAnimatorKey,
                rightAnimatorKey: _backSlidingPanelRightAnimatorKey,
              );
            },
          ),
        );
      },
    );
  }
}