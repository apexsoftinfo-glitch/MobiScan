import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../core/design/app_design_system.dart';
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
          extendBody: true,
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
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 100),
          painter: _BottomBarPainter(),
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.only(bottom: 20, left: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 95,
                child: _NavItem(
                  icon: Icons.home_rounded,
                  label: context.l10n.navHome,
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
              ),
              SizedBox(
                width: 95,
                child: _NavItem(
                  icon: Icons.menu_book_rounded,
                  label: context.l10n.navLibrary,
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
              ),
              SizedBox(
                width: 95,
                child: _NavItem(
                  icon: Icons.settings_rounded,
                  label: context.l10n.navSettings,
                  isActive: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 35,
          bottom: 50,
          child: GestureDetector(
            onTap: () {
              final userId = context.read<SessionCubit>().state.userIdOrNull;
              if (userId != null) {
                context.read<scanner_cubit.DocumentScannerCubit>().startScan(userId);
              }
            },
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppDesignSystem.charcoal,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppDesignSystem.charcoal.withValues(alpha: 0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 40),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFF7F4EB)
      ..style = PaintingStyle.fill;

    Path path = Path();
    double h = size.height;
    double w = size.width;
    double margin = 20;
    double radius = 40;

    path.moveTo(margin + radius, 20);
    
    // Line to where the right notch starts
    path.lineTo(w - 150, 20);
    
    // Notch on the right side
    path.cubicTo(w - 120, 20, w - 120, 0, w - 71, 0);
    path.cubicTo(w - 22, 0, w - 22, 20, w - 10, 20);
    
    path.lineTo(w - margin, 20);
    path.lineTo(w - margin, h);
    path.lineTo(margin, h);
    path.lineTo(margin, 20 + radius);
    path.arcToPoint(Offset(margin + radius, 20), radius: Radius.circular(radius));
    path.close();

    canvas.drawShadow(path, Colors.black, 15, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppDesignSystem.charcoal : AppDesignSystem.charcoal.withValues(alpha: 0.3),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? AppDesignSystem.charcoal : AppDesignSystem.charcoal.withValues(alpha: 0.3),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
