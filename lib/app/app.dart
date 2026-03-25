import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../l10n/l10n.dart';
import 'navigation/session_navigation_observer.dart';
import 'router/app_gate.dart';
import 'session/presentation/cubit/session_cubit.dart';
import 'theme/theme_cubit.dart';
import 'ui/missing_supabase_keys_screen.dart';

class App extends StatelessWidget {
  const App({required this.hasSupabaseKeys, super.key});

  final bool hasSupabaseKeys;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>.value(
      value: GetIt.I<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'MobiScan',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            themeMode: state.themeMode,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            home: _AppShell(hasSupabaseKeys: hasSupabaseKeys),
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF2F0EB),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF111111),
        brightness: Brightness.light,
        surface: const Color(0xFFFFFFFF),
        primary: const Color(0xFF111111),
        onPrimary: const Color(0xFFFFFFFF),
        secondary: const Color(0xFF444444),
        onSecondary: const Color(0xFFFFFFFF),
        error: const Color(0xFFB00020),
        onError: const Color(0xFFFFFFFF),
        onSurface: const Color(0xFF111111),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF2F0EB),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF111111),
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: Color(0xFF111111)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0xFF111111)),
          foregroundColor: WidgetStatePropertyAll(Color(0xFFFFFFFF)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          elevation: WidgetStatePropertyAll(0),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        selectedItemColor: Color(0xFF111111),
        unselectedItemColor: Color(0xFF9E9E9E),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      dividerColor: const Color(0xFFD0CFC9),
      cardTheme: const CardThemeData(
        color: Color(0xFFFFFFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Color(0xFFD0CFC9), width: 1.5),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF111111),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFF2F0EB),
        brightness: Brightness.dark,
        surface: const Color(0xFF1C1C1C),
        primary: const Color(0xFFF2F0EB),
        onPrimary: const Color(0xFF111111),
        secondary: const Color(0xFFAAAAAA),
        onSecondary: const Color(0xFF111111),
        error: const Color(0xFFCF6679),
        onError: const Color(0xFF111111),
        onSurface: const Color(0xFFF2F0EB),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF111111),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFFF2F0EB),
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: Color(0xFFF2F0EB)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0xFFF2F0EB)),
          foregroundColor: WidgetStatePropertyAll(Color(0xFF111111)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          elevation: WidgetStatePropertyAll(0),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1C1C1C),
        selectedItemColor: Color(0xFFF2F0EB),
        unselectedItemColor: Color(0xFF666666),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      dividerColor: const Color(0xFF333333),
      cardTheme: const CardThemeData(
        color: Color(0xFF1C1C1C),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Color(0xFF333333), width: 1.5),
        ),
      ),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.hasSupabaseKeys});

  final bool hasSupabaseKeys;

  @override
  Widget build(BuildContext context) {
    return hasSupabaseKeys
        ? BlocProvider<SessionCubit>.value(
            value: GetIt.I<SessionCubit>(),
            child: const SessionNavigationObserver(child: AppGate()),
          )
        : const MissingSupabaseKeysScreen();
  }
}
