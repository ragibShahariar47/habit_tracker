import 'package:habit_tracker/persistance/hive_data_store.dart';
import 'package:habit_tracker/ui/home/home_screen.dart';
import 'package:habit_tracker/ui/models/app_theme_settings.dart';
import 'package:habit_tracker/ui/models/front_or_back_side.dart';
import 'package:habit_tracker/ui/models/task.dart';
import 'package:habit_tracker/ui/theming/app_theme.dart';
import 'package:habit_tracker/ui/theming/app_theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/app_assets.dart';
import 'constants/app_colors.dart';

void main() async {
  final dataStore = HiveDataStore();
  await dataStore.init();
  await dataStore.createDemoTasks(
    force: false,
    frontTasks: [
      Task.create(name: 'Take Vitamins', taskIconName: AppAssets.vitamins),
      Task.create(name: 'Cycle to Work', taskIconName: AppAssets.bike),
      Task.create(name: 'Wash Your Hands', taskIconName: AppAssets.washHands),
      Task.create(name: 'Wear a Mask', taskIconName: AppAssets.mask),
      Task.create(name: 'Brush Your Teeth', taskIconName: AppAssets.toothbrush),
      Task.create(
        name: 'Floss Your Teeth',
        taskIconName: AppAssets.dentalFloss,
      ),
    ],
    backTasks: [
      Task.create(name: 'Do Karate', taskIconName: AppAssets.karate),
      Task.create(name: 'Go Running', taskIconName: AppAssets.run),
      Task.create(name: 'Go Swimming', taskIconName: AppAssets.swimmer),
      Task.create(
        name: 'Do Some Stretches',
        taskIconName: AppAssets.stretching,
      ),
      Task.create(name: 'Play Sports', taskIconName: AppAssets.basketball),
      Task.create(name: 'Spend Time Outside', taskIconName: AppAssets.sun),
    ],
  );

  final frontThemeSettings = await dataStore.appThemeSettings(
    side: FrontOrBackSide.front,
  );

  final backThemeSettings = await dataStore.appThemeSettings(
    side: FrontOrBackSide.back,
  );

  runApp(
    ProviderScope(
      overrides: [
        dataStoreProvider.overrideWithValue(dataStore),
        frontThemeSettingsProvider.overrideWith((ref) {
          return AppThemeManager(
            frontThemeSettings,
            dataStore,
            FrontOrBackSide.front,
          );
        }),
        backThemeSettingsProvider.overrideWith((ref) {
          return AppThemeManager(backThemeSettings, dataStore, .back);
        }),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
