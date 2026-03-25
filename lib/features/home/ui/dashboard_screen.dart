import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design/app_design_system.dart';
import '../../../l10n/l10n.dart';
import '../../../app/navigation/app_navigator.dart';
import '../../documents/presentation/cubit/document_list_cubit.dart' as list_cubit;
import '../../documents/presentation/cubit/document_scanner_cubit.dart' as scanner_cubit;

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

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.userId, required this.l10n});

  final String userId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<scanner_cubit.DocumentScannerCubit, scanner_cubit.DocumentScannerState>(
      builder: (context, state) {
        final isSaving = state is scanner_cubit.Saving;
        final isScanning = state is scanner_cubit.Scanning;
        final isLoading = isSaving || isScanning;
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.onSurface,
              foregroundColor: theme.scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(),
              elevation: 0,
            ),
            onPressed: isLoading
                ? null
                : () => context.read<scanner_cubit.DocumentScannerCubit>().startScan(userId),
            icon: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.scaffoldBackgroundColor,
                    ),
                  )
                : Icon(Icons.add, color: theme.scaffoldBackgroundColor, size: 22),
            label: Text(
              isSaving
                  ? l10n.savingLabel.toUpperCase()
                  : l10n.dashboardStartScan.toUpperCase(),
              style: TextStyle(
                color: theme.scaffoldBackgroundColor,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
          ),
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

  final dynamic doc;

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.name as String,
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
                    (doc.createdAt as DateTime)
                        .toLocal()
                        .toString()
                        .substring(0, 10),
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
              Icons.arrow_forward,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
