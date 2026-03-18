import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../l10n/l10n.dart';
import 'navigation/session_navigation_observer.dart';
import 'router/app_gate.dart';
import 'session/presentation/cubit/session_cubit.dart';
import 'ui/missing_supabase_keys_screen.dart';

class App extends StatelessWidget {
  const App({required this.hasSupabaseKeys, super.key});

  final bool hasSupabaseKeys;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobiScan',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
          surface: const Color(0xFFFFFFFF),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
            letterSpacing: -0.3,
          ),
          iconTheme: IconThemeData(color: Color(0xFF111827)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFFFFFFF),
          selectedItemColor: Color(0xFF4F46E5),
          unselectedItemColor: Color(0xFF9CA3AF),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11),
        ),
        dividerColor: const Color(0xFFE5E7EB),
        cardTheme: const CardThemeData(
          color: Color(0xFFFFFFFF),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
      ),
      home: _AppShell(hasSupabaseKeys: hasSupabaseKeys),
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
