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
      appBar: AppBar(
        title: const _LogoTitle(),
        backgroundColor: theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _GreetingSection(l10n: l10n),
              const SizedBox(height: 24),
              _StatsCard(l10n: l10n),
              const SizedBox(height: 24),
              _ScanButton(userId: userId, l10n: l10n),
              const SizedBox(height: 24),
              _RecentScansSection(l10n: l10n, userId: userId),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoTitle extends StatelessWidget {
  const _LogoTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            gradient: AppDesignSystem.primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.document_scanner_rounded, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          'MobiScan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: theme.textTheme.titleLarge?.color ?? const Color(0xFF111827),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dashboardGreeting,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: theme.textTheme.headlineLarge?.color ?? const Color(0xFF111827),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.dashboardGreetingSubtitle,
          style: TextStyle(
            fontSize: 15,
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6) ?? AppDesignSystem.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<list_cubit.DocumentListCubit, list_cubit.DocumentListState>(
      builder: (context, state) {
        final count = state is list_cubit.Success ? state.documents.length : 0;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDesignSystem.cardDecoration(color: theme.cardTheme.color),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppDesignSystem.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.folder_copy_rounded, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: theme.textTheme.displaySmall?.color ?? const Color(0xFF111827),
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    l10n.dashboardTotalScans,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? AppDesignSystem.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.userId, required this.l10n});

  final String userId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<scanner_cubit.DocumentScannerCubit, scanner_cubit.DocumentScannerState>(
      builder: (context, state) {
        final isSaving = state is scanner_cubit.Saving;
        final isScanning = state is scanner_cubit.Scanning;
        final isLoading = isSaving || isScanning;
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppDesignSystem.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppDesignSystem.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: isLoading
                ? null
                : () => context.read<scanner_cubit.DocumentScannerCubit>().startScan(userId),
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            label: Text(
              isSaving ? l10n.savingLabel : l10n.dashboardStartScan,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

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
        final recent = state.documents.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardRecentScans,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.titleMedium?.color ?? const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            ...recent.map(
              (doc) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => AppNavigator.goToDocumentDetail(context, doc),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: AppDesignSystem.cardDecoration(color: theme.cardTheme.color),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.article_rounded,
                              color: theme.colorScheme.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            doc.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: theme.textTheme.bodyLarge?.color ?? const Color(0xFF111827),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: theme.iconTheme.color?.withValues(alpha: 0.5) ?? AppDesignSystem.textSecondary, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
