import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/design/app_design_system.dart';
import '../../../../l10n/l10n.dart';
import '../../models/document_model.dart';
import '../cubit/document_detail_cubit.dart';
import '../cubit/pdf_export_cubit.dart';

class DocumentDetailScreen extends StatelessWidget {
  const DocumentDetailScreen({super.key, required this.document});
  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<DocumentDetailCubit>()),
        BlocProvider(create: (context) => getIt<PdfExportCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<DocumentDetailCubit, DocumentDetailState>(
            listener: (context, state) {
              state.maybeMap(
                success: (s) {
                  if (s.successKey == 'document_deleted') {
                    Navigator.of(context).pop();
                  } else if (s.successKey == 'document_renamed') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.documentRenamedSnackbar),
                        backgroundColor: AppDesignSystem.accent,
                      ),
                    );
                  }
                },
                error: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.errorUnknown)),
                  );
                },
                orElse: () {},
              );
            },
          ),
          BlocListener<PdfExportCubit, PdfExportState>(
            listener: (context, state) {
              state.maybeMap(
                error: (e) {
                  final errorMsg = e.errorKey == 'no_pages_error'
                      ? l10n.noPagesError
                      : l10n.errorUnknown;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMsg)),
                  );
                },
                orElse: () {},
              );
            },
          ),
        ],
        child: _DocumentDetailView(document: document),
      ),
    );
  }
}

class _DocumentDetailView extends StatelessWidget {
  const _DocumentDetailView({required this.document});
  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          document.name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showRenameDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: document.pages.length,
              itemBuilder: (context, index) {
                final page = document.pages[index];
                return _PageThumbnail(
                  path: page.storagePath,
                  index: index + 1,
                  documentId: document.id,
                );
              },
            ),
          ),
          _ExportButton(document: document, l10n: l10n),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final l10n = context.l10n;
    final controller = TextEditingController(text: document.name);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.renameDocumentDialogTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: l10n.searchScansPlaceholder,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              context.read<DocumentDetailCubit>().renameDocument(
                    id: document.id,
                    newName: controller.text,
                  );
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.saveFirstNameButtonLabel),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: Text(l10n.deleteAccountDialogTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(l10n.deleteAccountDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(diagContext),
            child: Text(l10n.cancelButtonLabel),
          ),
          TextButton(
            onPressed: () {
              context.read<DocumentDetailCubit>().deleteDocument(document.id);
              Navigator.pop(diagContext);
            },
            child: Text(
              'Usuń',
              style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton({required this.document, required this.l10n});

  final DocumentModel document;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: BlocBuilder<PdfExportCubit, PdfExportState>(
        builder: (context, state) {
          final isGenerating = state is Generating;
          return Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppDesignSystem.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppDesignSystem.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: isGenerating
                  ? null
                  : () => context.read<PdfExportCubit>().exportToPdf(document),
              icon: isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.share_rounded, color: Colors.white),
              label: Text(
                isGenerating ? l10n.generatingPdfLabel : l10n.exportPdfButtonLabel,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PageThumbnail extends StatelessWidget {
  const _PageThumbnail({required this.path, required this.index, required this.documentId});
  final String path;
  final int index;
  final String documentId;

  Future<String> _resolvePath() async {
    if (path.contains('/') || path.contains('\\')) {
      // It's already an absolute path (or at least looks like one)
      return path;
    }
    final appDocDir = await getApplicationDocumentsDirectory();
    return p.join(appDocDir.path, path);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _resolvePath(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final resolvedPath = snapshot.data!;
        final file = File(resolvedPath);

        return Hero(
          tag: 'page_${documentId}_$index',
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppDesignSystem.outline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                file.existsSync()
                    ? Image.file(file, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
                      ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$index',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
