import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_cubit.freezed.dart';

@freezed
sealed class ThemeState with _$ThemeState {
  const factory ThemeState.initial({
    required ThemeMode themeMode,
  }) = Initial;
}

@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._prefs) : super(const ThemeState.initial(themeMode: ThemeMode.system)) {
    _loadTheme();
  }

  final SharedPreferences _prefs;
  static const _themeKey = 'theme_mode';

  void _loadTheme() {
    final index = _prefs.getInt(_themeKey);
    if (index != null && index < ThemeMode.values.length) {
      emit(ThemeState.initial(themeMode: ThemeMode.values[index]));
    }
  }

  void setThemeMode(ThemeMode mode) {
    emit(ThemeState.initial(themeMode: mode));
    _prefs.setInt(_themeKey, mode.index);
  }

  void toggleTheme() {
    final nextMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(nextMode);
  }
}
