import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../l10n/l10n.dart';
import '../../features/documents/presentation/cubit/document_list_cubit.dart' as list_cubit;
import '../../features/documents/presentation/cubit/document_scanner_cubit.dart' as scanner_cubit;
import '../../app/session/presentation/cubit/session_cubit.dart';
import '../../features/home/ui/dashboard_screen.dart';
import '../../features/home/ui/scans_screen.dart';
import '../../features/home/ui/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = context.watch<SessionCubit>().state.userIdOrNull;

    if (userId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocProvider(
      create: (context) => getIt<scanner_cubit.DocumentScannerCubit>(),
      child: BlocListener<scanner_cubit.DocumentScannerCubit, scanner_cubit.DocumentScannerState>(
        listener: (context, state) {
          if (state is scanner_cubit.Success) {
            context.read<list_cubit.DocumentListCubit>().loadDocuments(userId);
          }
          if (state is scanner_cubit.Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.errorUnknown)),
            );
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              DashboardScreen(userId: userId),
              ScansScreen(userId: userId),
              const SettingsScreen(),
            ],
          ),
          bottomNavigationBar: _BottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        border: Border(
          top: BorderSide(color: theme.dividerColor, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            activeIcon: const Icon(Icons.home_rounded),
            label: l10n.navDashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.description_outlined),
            activeIcon: const Icon(Icons.description_rounded),
            label: l10n.navMyScans,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings_rounded),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
