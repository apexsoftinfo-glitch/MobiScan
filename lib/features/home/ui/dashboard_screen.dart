import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design/app_design_system.dart';
import '../../../l10n/l10n.dart';
import '../../../app/navigation/app_navigator.dart';
import '../../documents/presentation/cubit/document_list_cubit.dart' as list_cubit;
import '../../documents/presentation/cubit/document_scanner_cubit.dart' as scanner_cubit;
import '../../documents/presentation/ui/widgets/document_thumbnail.dart';
import '../../documents/models/document_model.dart';

import '../../../app/session/presentation/cubit/session_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppDesignSystem.background,
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppDesignSystem.mintLight.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ColorFilter.mode(
                  AppDesignSystem.background.withValues(alpha: 0.1),
                  BlendMode.dstATop,
                ),
                child: Container(),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: AppDesignSystem.orangeLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GreetingSection(l10n: l10n),
                  const SizedBox(height: 12),
                  _ScanCard(userId: userId, l10n: l10n),
                  const SizedBox(height: 32),
                  _RecentScansSection(l10n: l10n, userId: userId),
                ],
              ),
            ),
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<SessionCubit, SessionState>(
                  builder: (context, state) {
                    final firstName = state.sharedUserOrNull?.firstName ?? l10n.guestDisplayName;
                    return Text(
                      l10n.dashboardGreetingName(firstName),
                      style: AppDesignSystem.headline(context).copyWith(
                        fontSize: 28,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.dashboardWelcomeBack,
                  style: AppDesignSystem.body(context).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppDesignSystem.textSecondary.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Badge(
              backgroundColor: AppDesignSystem.accent,
              smallSize: 8,
              child: Icon(Icons.notifications_none_rounded, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}


// ─── Scan button ──────────────────────────────────────────────────────────

class _ScanCard extends StatefulWidget {
  const _ScanCard({required this.userId, required this.l10n});

  final String userId;
  final AppLocalizations l10n;

  @override
  State<_ScanCard> createState() => _ScanCardState();
}

class _ScanCardState extends State<_ScanCard>
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
        final isLoading = state is scanner_cubit.Saving || state is scanner_cubit.Scanning;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: AppDesignSystem.cardDecoration(
              borderRadius: BorderRadius.circular(48),
            ).copyWith(
              gradient: AppDesignSystem.scanCardGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.document_scanner_outlined,
                        size: 40,
                        color: AppDesignSystem.accent,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.l10n.dashboardNewScan,
                            style: AppDesignSystem.headline(context).copyWith(
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.l10n.dashboardCaptureDocument,
                            style: AppDesignSystem.body(context).copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppDesignSystem.textPrimary,
                            ),
                          ),
                          Text(
                            widget.l10n.dashboardScanWithCamera,
                            style: AppDesignSystem.body(context).copyWith(
                              fontSize: 13,
                              color: AppDesignSystem.textSecondary.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return GestureDetector(
                          onTap: isLoading ? null : () => context
                              .read<scanner_cubit.DocumentScannerCubit>()
                              .startScan(widget.userId),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppDesignSystem.charcoal,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00E676).withValues(
                                    alpha: 0.3 + (0.4 * _animation.value),
                                  ),
                                  blurRadius: 10 + (15 * _animation.value),
                                  spreadRadius: 2 * _animation.value,
                                  offset: Offset(0, 4 + (4 * _animation.value)),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  widget.l10n.dashboardStartScanning,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
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
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Text(
                l10n.dashboardRecentDocuments,
                style: AppDesignSystem.headline(context).copyWith(
                  fontSize: 20,
                ),
              ),
            ),
            ...recent.map(
              (doc) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _RecentScanRow(doc: doc),
              ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Container(
        decoration: AppDesignSystem.cardDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => AppNavigator.goToDocumentDetail(context, doc),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                DocumentThumbnail(document: doc, size: 48),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.name,
                        style: AppDesignSystem.headline(context).copyWith(
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${doc.pages.length} pages · ${doc.createdAt.toLocal().toString().substring(0, 10)}',
                        style: AppDesignSystem.body(context).copyWith(
                          fontSize: 12,
                          color: AppDesignSystem.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppDesignSystem.highlight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'PDF',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: AppDesignSystem.highlight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
