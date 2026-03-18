import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../core/design/app_design_system.dart';
import '../../../l10n/l10n.dart';
import '../../documents/presentation/cubit/document_list_cubit.dart';
import '../../documents/models/document_model.dart';

class ScansScreen extends StatelessWidget {
  const ScansScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(l10n.navMyScans),
        backgroundColor: const Color(0xFFF7F8FA),
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<DocumentListCubit, DocumentListState>(
        builder: (context, state) {
          return switch (state) {
            Success(documents: final docs) => docs.isEmpty
                ? _EmptyScansView(l10n: l10n)
                : _ScansList(documents: docs),
            Error() => _ErrorView(
                l10n: l10n,
                onRetry: () =>
                    context.read<DocumentListCubit>().retry(userId),
              ),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }
}

class _EmptyScansView extends StatelessWidget {
  const _EmptyScansView({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              child: const Icon(
                Icons.description_outlined,
                size: 40,
                color: AppDesignSystem.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.noScansTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noScansBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppDesignSystem.textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.l10n, required this.onRetry});

  final AppLocalizations l10n;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectableText(
            l10n.errorUnknown,
            style: const TextStyle(color: AppDesignSystem.textSecondary),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: Text(l10n.retryButtonLabel),
          ),
        ],
      ),
    );
  }
}

class _ScansList extends StatelessWidget {
  const _ScansList({required this.documents});

  final List<DocumentModel> documents;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: documents.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final doc = documents[index];
        return _ScanCard(document: doc);
      },
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({required this.document});

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
              child: const Icon(
                Icons.article_rounded,
                color: AppDesignSystem.primary,
                size: 24,
              ),
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
                  const SizedBox(height: 3),
                  Text(
                    '${document.pages.length} stron · ${document.createdAt.toLocal().toString().substring(0, 10)}',
                    style: const TextStyle(
                      color: AppDesignSystem.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppDesignSystem.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
