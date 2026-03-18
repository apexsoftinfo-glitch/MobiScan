import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../core/design/app_design_system.dart';
import '../../../l10n/l10n.dart';
import '../../documents/presentation/cubit/document_list_cubit.dart';
import '../../documents/models/document_model.dart';

class ScansScreen extends StatefulWidget {
  const ScansScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ScansScreen> createState() => _ScansScreenState();
}

class _ScansScreenState extends State<ScansScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.navMyScans),
        backgroundColor: theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        actions: [
          _SortMenu(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => context.read<DocumentListCubit>().updateSearch(value),
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: l10n.searchScansPlaceholder,
                hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5)),
                prefixIcon: Icon(Icons.search_rounded, size: 20, color: theme.colorScheme.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          context.read<DocumentListCubit>().updateSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.cardTheme.color,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<DocumentListCubit, DocumentListState>(
              builder: (context, state) {
                return switch (state) {
                  Success() => state.filteredDocuments.isEmpty
                      ? _EmptyScansView(
                          l10n: l10n,
                          isSearch: state.searchQuery.isNotEmpty,
                        )
                      : _ScansList(documents: state.filteredDocuments),
                  Error() => _ErrorView(
                      l10n: l10n,
                      onRetry: () => context.read<DocumentListCubit>().retry(widget.userId),
                    ),
                  _ => const Center(child: CircularProgressIndicator()),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SortMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentListCubit, DocumentListState>(
      builder: (context, state) {
        final currentOrder = state.sortOrder;
        return PopupMenuButton<DocumentSortOrder>(
          icon: const Icon(Icons.sort_rounded),
          onSelected: (order) => context.read<DocumentListCubit>().updateSort(order),
          itemBuilder: (context) => [
            CheckedPopupMenuItem(
              value: DocumentSortOrder.dateDesc,
              checked: currentOrder == DocumentSortOrder.dateDesc,
              child: const Text('Najnowsze'),
            ),
            CheckedPopupMenuItem(
              value: DocumentSortOrder.dateAsc,
              checked: currentOrder == DocumentSortOrder.dateAsc,
              child: const Text('Najstarsze'),
            ),
            CheckedPopupMenuItem(
              value: DocumentSortOrder.nameAsc,
              checked: currentOrder == DocumentSortOrder.nameAsc,
              child: const Text('Nazwa A-Z'),
            ),
            CheckedPopupMenuItem(
              value: DocumentSortOrder.nameDesc,
              checked: currentOrder == DocumentSortOrder.nameDesc,
              child: const Text('Nazwa Z-A'),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyScansView extends StatelessWidget {
  const _EmptyScansView({required this.l10n, required this.isSearch});

  final AppLocalizations l10n;
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                isSearch ? Icons.search_off_rounded : Icons.description_outlined,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSearch ? "Brak wyników" : l10n.noScansTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearch ? "Nie znaleźliśmy skanów pasujących do Twojego zapytania." : l10n.noScansBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
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
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectableText(
            l10n.errorUnknown,
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => AppNavigator.goToDocumentDetail(context, document),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDesignSystem.cardDecoration(color: theme.cardTheme.color),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.article_rounded,
                color: theme.colorScheme.primary,
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
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${document.pages.length} stron · ${document.createdAt.toLocal().toString().substring(0, 10)}',
                    style: TextStyle(
                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: theme.colorScheme.error.withValues(alpha: 0.7),
                size: 20,
              ),
              onPressed: () => _showDeleteConfirmation(context),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.iconTheme.color?.withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: Text(l10n.deleteDocumentDialogTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(l10n.deleteDocumentDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(diagContext),
            child: Text(l10n.cancelButtonLabel),
          ),
          TextButton(
            onPressed: () {
              context.read<DocumentListCubit>().deleteDocument(document.id);
              Navigator.pop(diagContext);
            },
            child: Text(
              'Usuń',
              style: TextStyle(
                  color: Colors.red.shade600, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
