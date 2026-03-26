import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../app/navigation/app_navigator.dart';
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
        title: Text(
          l10n.navMyScans.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        actions: [_SortMenu()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: theme.dividerColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  context.read<DocumentListCubit>().updateSearch(value),
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: l10n.searchScansPlaceholder,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          context.read<DocumentListCubit>().updateSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.cardTheme.color,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: theme.dividerColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: theme.dividerColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide:
                      BorderSide(color: theme.colorScheme.onSurface, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                      onRetry: () =>
                          context.read<DocumentListCubit>().retry(widget.userId),
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
    final theme = Theme.of(context);
    return BlocBuilder<DocumentListCubit, DocumentListState>(
      builder: (context, state) {
        final currentOrder = state.sortOrder;
        return PopupMenuButton<DocumentSortOrder>(
          icon: Icon(Icons.sort, color: theme.colorScheme.onSurface),
          onSelected: (order) =>
              context.read<DocumentListCubit>().updateSort(order),
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
            Icon(
              isSearch ? Icons.search_off : Icons.description_outlined,
              size: 56,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 20),
            Text(
              isSearch ? 'BRAK WYNIKÓW' : l10n.noScansTitle.toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearch
                  ? 'Nie znaleźliśmy skanów pasujących do Twojego zapytania.'
                  : l10n.noScansBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 14,
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
          SelectableText(l10n.errorUnknown),
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
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return _ScanRow(document: doc);
      },
    );
  }
}

class _ScanRow extends StatelessWidget {
  const _ScanRow({required this.document});

  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: () => AppNavigator.goToDocumentDetail(context, document),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                _DocumentThumbnail(document: document),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.name,
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
                        '${document.pages.length} str  ·  ${document.createdAt.toLocal().toString().substring(0, 10)}',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.3,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  onPressed: () => _showDeleteConfirmation(context),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: theme.dividerColor, indent: 20, endIndent: 20),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        shape: const RoundedRectangleBorder(),
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

class _DocumentThumbnail extends StatelessWidget {
  const _DocumentThumbnail({required this.document});

  final DocumentModel document;

  Future<String?> _resolveFirstPagePath() async {
    if (document.pages.isEmpty) return null;
    final path = document.pages.first.storagePath;
    if (path.contains('/') || path.contains('\\')) return path;
    final appDocDir = await getApplicationDocumentsDirectory();
    return p.join(appDocDir.path, path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pageCount = document.pages.length;
    const size = 44.0;

    return FutureBuilder<String?>(
      future: _resolveFirstPagePath(),
      builder: (context, snapshot) {
        final resolvedPath = snapshot.data;
        final file = resolvedPath != null ? File(resolvedPath) : null;
        final imageExists = file != null && file.existsSync();

        return SizedBox(
          width: size + (pageCount > 1 ? 4 : 0),
          height: size + (pageCount > 1 ? 4 : 0),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              // Background card (multi-page indicator)
              if (pageCount > 1)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ),
              // Main thumbnail
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: size,
                  height: size,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color ?? theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                    ),
                  ),
                  child: imageExists
                      ? Image.file(file, fit: BoxFit.cover)
                      : Icon(
                          Icons.article_outlined,
                          size: 22,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                ),
              ),
              // Page count badge
              if (pageCount > 1)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      '$pageCount',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
