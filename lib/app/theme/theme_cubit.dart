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
    Locale? locale,
  }) = Initial;
}

@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._prefs) : super(const ThemeState.initial(themeMode: ThemeMode.system)) {
    _loadSettings();
  }

  final SharedPreferences _prefs;
  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale_code';

  void _loadSettings() {
    final themeIndex = _prefs.getInt(_themeKey);
    final localeCode = _prefs.getString(_localeKey);
    
    ThemeMode mode = ThemeMode.system;
    if (themeIndex != null && themeIndex < ThemeMode.values.length) {
      mode = ThemeMode.values[themeIndex];
    }

    Locale? locale;
    if (localeCode != null) {
      locale = Locale(localeCode);
    }

    emit(ThemeState.initial(themeMode: mode, locale: locale));
  }

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
    _prefs.setInt(_themeKey, mode.index);
  }

  void setLocale(Locale? locale) {
    emit(state.copyWith(locale: locale));
    if (locale == null) {
      _prefs.remove(_localeKey);
    } else {
      _prefs.setString(_localeKey, locale.languageCode);
    }
  }

  void toggleTheme() {
    final nextMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(nextMode);
  }
}
