import 'package:habit_tracker/persistance/hive_data_store.dart';
import 'package:habit_tracker/ui/models/app_theme_settings.dart';
import 'package:habit_tracker/ui/models/front_or_back_side.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppThemeManager extends StateNotifier<AppThemeSettings> {
  AppThemeManager(super.state, this.dataStore, this.side);

  final HiveDataStore dataStore;
  final FrontOrBackSide side;

  void updateColorIndex(int colorIndex) {
    state = state.copyWith(colorIndex: colorIndex);
    dataStore.setAppThemeSettings(settings: state, side: side);
  }

  void updateVariantIndex(int variantIndex) {
    state = state.copyWith(variantIndex: variantIndex);
    dataStore.setAppThemeSettings(settings: state, side: side);
  }

}

final frontThemeSettingsProvider = StateNotifierProvider<
    AppThemeManager,
    AppThemeSettings>((ref) {
  throw UnimplementedError();
});

final backThemeSettingsProvider = StateNotifierProvider<
    AppThemeManager,
    AppThemeSettings>((ref) {
  throw UnimplementedError();
});