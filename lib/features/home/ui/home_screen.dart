import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../l10n/l10n.dart';
import '../../../core/di/injection.dart';
import '../../../core/design/app_design_system.dart';
import '../../documents/presentation/cubit/document_list_cubit.dart' as list_cubit;
import '../../documents/presentation/cubit/document_scanner_cubit.dart' as scanner_cubit;
import '../../documents/models/document_model.dart';

// HomeScreen is kept for legacy navigation references but is not the main entry
// point anymore — MainShell now hosts DashboardScreen and ScansScreen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = context.watch<SessionCubit>().state.userIdOrNull;

    if (userId == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<scanner_cubit.DocumentScannerCubit>(),
        ),
      ],
      child: BlocListener<scanner_cubit.DocumentScannerCubit, scanner_cubit.DocumentScannerState>(
        listener: (context, state) {
          if (state is scanner_cubit.Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.errorUnknown)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          appBar: AppBar(
            title: Text(l10n.homeTitle),
            backgroundColor: const Color(0xFFF7F8FA),
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                onPressed: () => AppNavigator.goToProfile(context),
                icon: const Icon(Icons.person_outline_rounded),
              ),
            ],
          ),
          body: BlocBuilder<list_cubit.DocumentListCubit, list_cubit.DocumentListState>(
            builder: (context, state) {
              return switch (state) {
                list_cubit.Success(documents: final docs) => docs.isEmpty
                    ? _NoScansView()
                    : _DocumentsListView(documents: docs),
                list_cubit.Error() => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SelectableText(
                          l10n.errorUnknown,
                          style: const TextStyle(color: AppDesignSystem.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () =>
                              context.read<list_cubit.DocumentListCubit>().retry(userId),
                          child: Text(l10n.retryButtonLabel),
                        ),
                      ],
                    ),
                  ),
                _ => const Center(child: CircularProgressIndicator()),
              };
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton:
              BlocBuilder<scanner_cubit.DocumentScannerCubit, scanner_cubit.DocumentScannerState>(
            builder: (context, state) {
              final isSaving = state is scanner_cubit.Saving;
              return Container(
                decoration: BoxDecoration(
                  gradient: AppDesignSystem.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppDesignSystem.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  onPressed: isSaving
                      ? null
                      : () => context
                          .read<scanner_cubit.DocumentScannerCubit>()
                          .startScan(userId),
                  icon: isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.document_scanner, color: Colors.white),
                  label: Text(
                    isSaving ? l10n.savingLabel : l10n.addScanButtonLabel,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NoScansView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppDesignSystem.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.description_outlined, size: 40, color: AppDesignSystem.primary),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noScansTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noScansBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppDesignSystem.textSecondary, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentsListView extends StatelessWidget {
  const _DocumentsListView({required this.documents});
  final List<DocumentModel> documents;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: documents.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final doc = documents[index];
        return _DocumentCard(document: doc);
      },
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});
  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigator.goToDocumentDetail(context, document),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDesignSystem.cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppDesignSystem.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.article_rounded, color: AppDesignSystem.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${document.pages.length} stron · ${document.createdAt.toLocal().toString().substring(0, 10)}',
                    style: const TextStyle(color: AppDesignSystem.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppDesignSystem.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
