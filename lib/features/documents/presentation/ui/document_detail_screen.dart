import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
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
                      SnackBar(content: Text(l10n.documentRenamedSnackbar)),
                    );
                  }
                },
                error: (e) {
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
      appBar: AppBar(
        title: Text(document.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showRenameDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: document.pages.length,
              itemBuilder: (context, index) {
                final page = document.pages[index];
                return _PageThumbnail(path: page.storagePath, index: index + 1);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<PdfExportCubit, PdfExportState>(
              builder: (context, state) {
                final isGenerating = state is Generating;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isGenerating 
                      ? null 
                      : () => context.read<PdfExportCubit>().exportToPdf(document),
                    icon: isGenerating 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.share),
                    label: Text(isGenerating ? l10n.generatingPdfLabel : l10n.exportPdfButtonLabel),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final l10n = context.l10n;
    final controller = TextEditingController(text: document.name);
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: Text(l10n.renameDocumentDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.searchScansPlaceholder),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(diagContext),
            child: Text(l10n.cancelButtonLabel),
          ),
          TextButton(
            onPressed: () {
              context.read<DocumentDetailCubit>().renameDocument(
                id: document.id,
                newName: controller.text,
              );
              Navigator.pop(diagContext);
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
        title: Text(l10n.deleteAccountDialogTitle), // Reuse or add new key
        content: Text(l10n.deleteAccountDialogBody), // Reuse or add new key
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
            child: Text(l10n.deleteAccountButtonLabel),
          ),
        ],
      ),
    );
  }
}

class _PageThumbnail extends StatelessWidget {
  const _PageThumbnail({required this.path, required this.index});
  final String path;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(path), fit: BoxFit.cover),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$index',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
