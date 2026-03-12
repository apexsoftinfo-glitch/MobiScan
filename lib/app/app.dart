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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D12),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
          surface: const Color(0xFF1C1C23),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF9FAFB),
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
