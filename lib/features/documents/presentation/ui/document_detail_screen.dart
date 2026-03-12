import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                error: (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.errorUnknown),
                      backgroundColor: Colors.redAccent,
                    ),
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
                    SnackBar(
                      content: Text(errorMsg),
                      backgroundColor: Colors.redAccent,
                    ),
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
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppDesignSystem.glassEffect(
          child: AppBar(
            title: Text(document.name, style: const TextStyle(fontWeight: FontWeight.w800)),
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
        ),
      ),
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppDesignSystem.secondary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 32, 16, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
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
              Padding(
                padding: const EdgeInsets.all(24),
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
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.share_rounded, color: Colors.white),
                        label: Text(
                          isGenerating ? l10n.generatingPdfLabel : l10n.exportPdfButtonLabel,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final l10n = context.l10n;
    final controller = TextEditingController(text: document.name);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AppDesignSystem.glassEffect(
              borderRadius: BorderRadius.circular(24),
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(l10n.renameDocumentDialogTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: l10n.searchScansPlaceholder,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancelButtonLabel, style: const TextStyle(color: AppDesignSystem.textSecondary)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppDesignSystem.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      context.read<DocumentDetailCubit>().renameDocument(
                        id: document.id,
                        newName: controller.text,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(l10n.saveFirstNameButtonLabel, style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (diagContext) => AppDesignSystem.glassEffect(
        borderRadius: BorderRadius.circular(24),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(l10n.deleteAccountDialogTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(l10n.deleteAccountDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(diagContext),
              child: Text(l10n.cancelButtonLabel, style: const TextStyle(color: AppDesignSystem.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                context.read<DocumentDetailCubit>().deleteDocument(document.id);
                Navigator.pop(diagContext);
              },
              child: const Text('Usuń', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageThumbnail extends StatelessWidget {
  const _PageThumbnail({required this.path, required this.index, required this.documentId});
  final String path;
  final int index;
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'page_${documentId}_$index',
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(File(path), fit: BoxFit.cover),
            Positioned(
              bottom: 8,
              right: 8,
              child: AppDesignSystem.glassEffect(
                borderRadius: BorderRadius.circular(8),
                opacity: 0.3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '$index',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
