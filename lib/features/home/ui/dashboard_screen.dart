import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design/app_design_system.dart';
import '../../../l10n/l10n.dart';
import '../../../app/navigation/app_navigator.dart';
import 'dart:ui';
import '../../documents/presentation/cubit/document_list_cubit.dart' as list_cubit;
import '../../documents/presentation/cubit/document_scanner_cubit.dart' as scanner_cubit;
import '../../documents/presentation/ui/widgets/document_thumbnail.dart';
import '../../documents/models/document_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GreetingSection(l10n: l10n),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _StatsRow(l10n: l10n),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ScanButton(userId: userId, l10n: l10n),
              ),
              const SizedBox(height: 32),
              _RecentScansSection(l10n: l10n, userId: userId),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Greeting ─────────────────────────────────────────────────────────────


class _GreetingSection extends StatelessWidget {
  const _GreetingSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dashboardGreeting,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
              letterSpacing: -2,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.dashboardGreetingSubtitle.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stats ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<list_cubit.DocumentListCubit, list_cubit.DocumentListState>(
      builder: (context, state) {
        final count = state is list_cubit.Success ? state.documents.length : 0;
        return Container(
          decoration: AppDesignSystem.accentLeftBorder(
            bg: theme.cardTheme.color,
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                      color: theme.colorScheme.onSurface,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    l10n.dashboardTotalScans.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Icon(
                Icons.description_outlined,
                size: 36,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Scan button ──────────────────────────────────────────────────────────

class _ScanButton extends StatefulWidget {
  const _ScanButton({required this.userId, required this.l10n});

  final String userId;
  final AppLocalizations l10n;

  @override
  State<_ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<_ScanButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<scanner_cubit.DocumentScannerCubit,
        scanner_cubit.DocumentScannerState>(
      builder: (context, state) {
        final isSaving = state is scanner_cubit.Saving;
        final isScanning = state is scanner_cubit.Scanning;
        final isLoading = isSaving || isScanning;

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final glowValue = _animation.value;
            return GestureDetector(
              onTap: isLoading
                  ? null
                  : () => context
                      .read<scanner_cubit.DocumentScannerCubit>()
                      .startScan(widget.userId),
              child: Transform.scale(
                scale: 1.0 + (glowValue * 0.02),
                child: Container(
                  width: double.infinity,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(
                          alpha: 0.2 + (glowValue * 0.3),
                        ),
                        blurRadius: 15 + (glowValue * 15),
                        spreadRadius: 2 + (glowValue * 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF6366F1).withValues(alpha: 0.85),
                              const Color(0xFF4338CA).withValues(alpha: 0.7),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isLoading)
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                Icon(
                                  Icons.document_scanner_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              const SizedBox(width: 12),
                              Text(
                                isSaving
                                    ? widget.l10n.savingLabel.toUpperCase()
                                    : widget.l10n.dashboardStartScan.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Recent scans ─────────────────────────────────────────────────────────

class _RecentScansSection extends StatelessWidget {
  const _RecentScansSection({required this.l10n, required this.userId});

  final AppLocalizations l10n;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<list_cubit.DocumentListCubit, list_cubit.DocumentListState>(
      builder: (context, state) {
        if (state is! list_cubit.Success || state.documents.isEmpty) {
          return const SizedBox.shrink();
        }
        final recent = state.documents.take(5).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                l10n.dashboardRecentScans.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
            ...recent.map(
              (doc) => _RecentScanRow(doc: doc),
            ),
          ],
        );
      },
    );
  }
}

class _RecentScanRow extends StatelessWidget {
  const _RecentScanRow({required this.doc});

  final DocumentModel doc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => AppNavigator.goToDocumentDetail(context, doc),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            DocumentThumbnail(document: doc, size: 48),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${doc.pages.length} str  ·  ${doc.createdAt.toLocal().toString().substring(0, 10)}',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}
