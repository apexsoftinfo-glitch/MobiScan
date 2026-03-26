import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.showMaterialBanner(
                      MaterialBanner(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        backgroundColor: const Color(0xFF4CAF50),
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_outline,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 10),
                            Text(
                              l10n.documentRenamedSnackbar,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: messenger.clearMaterialBanners,
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    Future.delayed(const Duration(milliseconds: 2500), () {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).clearMaterialBanners();
                      }
                    });
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: BlocBuilder<DocumentDetailCubit, DocumentDetailState>(
          builder: (context, state) {
            final newName = state.maybeMap(
              success: (s) => s.newName,
              orElse: () => null,
            );
            return Text(
              newName ?? document.name,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
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
                  allPages: document.pages.map((p) => p.storagePath).toList(),
                );
              },
            ),
          ),
          _ExportButton(document: document),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
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
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: l10n.searchScansPlaceholder,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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

class _ExportButton extends StatefulWidget {
  const _ExportButton({required this.document});
  final DocumentModel document;

  @override
  State<_ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<_ExportButton>
    with TickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;
  late final AnimationController _flyCtrl;
  late final Animation<double> _shimmerAnim;
  late final Animation<double> _flyOffset;
  late final Animation<double> _flyOpacity;

  @override
  void initState() {
    super.initState();

    // Shimmer sweep across the button — slow, 2 s loop
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shimmerAnim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );

    // Icon flying up and fading — 1.2 s loop
    _flyCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _flyOffset = Tween<double>(begin: 0, end: -18).animate(
      CurvedAnimation(parent: _flyCtrl, curve: Curves.easeIn),
    );
    _flyOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _flyCtrl,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _flyCtrl.dispose();
    super.dispose();
  }

  void _startAnimations() {
    _shimmerCtrl.repeat();
    _flyCtrl.repeat();
  }

  void _stopAnimations() {
    _shimmerCtrl.stop();
    _shimmerCtrl.reset();
    _flyCtrl.stop();
    _flyCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: BlocBuilder<PdfExportCubit, PdfExportState>(
        builder: (context, state) {
          final isGenerating = state is Generating;

          if (isGenerating) {
            _startAnimations();
          } else {
            _stopAnimations();
          }

          return Builder(
            builder: (btnContext) {
              return GestureDetector(
                onTap: isGenerating
                    ? null
                    : () {
                        final box =
                            btnContext.findRenderObject() as RenderBox?;
                        final offset = box?.localToGlobal(Offset.zero);
                        final rect = offset != null && box != null
                            ? offset & box.size
                            : null;
                        context.read<PdfExportCubit>().exportToPdf(
                              widget.document,
                              sharePositionOrigin: rect,
                            );
                      },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: AnimatedBuilder(
                      animation:
                          Listenable.merge([_shimmerAnim, _flyOffset]),
                      builder: (context, _) {
                        return Container(
                          height: 58,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF4CAF50).withValues(alpha: 0.45),
                                const Color(0xFF2E7D32).withValues(alpha: 0.28),
                                const Color(0xFF66BB6A).withValues(alpha: 0.38),
                              ],
                            ),
                            border: Border.all(
                              color: const Color(0xFF81C784).withValues(alpha: 0.55),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withValues(alpha: 0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Shimmer sweep (only while generating)
                              if (isGenerating)
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Transform.translate(
                                      offset: Offset(
                                        _shimmerAnim.value *
                                            300,
                                        0,
                                      ),
                                      child: Container(
                                        width: 80,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white
                                                  .withValues(alpha: 0),
                                              const Color(0xFFA5D6A7)
                                                  .withValues(alpha: 0.45),
                                              Colors.white
                                                  .withValues(alpha: 0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              // Button content
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon — flies up and fades when generating
                                    if (isGenerating)
                                      Transform.translate(
                                        offset: Offset(0, _flyOffset.value),
                                        child: FadeTransition(
                                          opacity: _flyOpacity,
                                          child: const Icon(
                                            Icons.send_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    else
                                      const Icon(
                                        Icons.share_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      isGenerating
                                          ? l10n.generatingPdfLabel
                                          : l10n.exportPdfButtonLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class _PageThumbnail extends StatelessWidget {
  const _PageThumbnail({
    required this.path,
    required this.index,
    required this.documentId,
    required this.allPages,
  });
  final String path;
  final int index;
  final String documentId;
  final List<String> allPages;

  Future<String> _resolvePath() async {
    if (path.contains('/') || path.contains('\\')) {
      return path;
    }
    final appDocDir = await getApplicationDocumentsDirectory();
    return p.join(appDocDir.path, path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FutureBuilder<String>(
      future: _resolvePath(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              color: theme.cardTheme.color?.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final resolvedPath = snapshot.data!;
        final file = File(resolvedPath);

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => _FullscreenImageViewer(
                  paths: allPages,
                  initialIndex: index - 1,
                  documentId: documentId,
                ),
              ),
            );
          },
          child: Hero(
            tag: 'page_${documentId}_$index',
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
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
                          color: theme.cardTheme.color,
                          child: Icon(Icons.broken_image_outlined,
                              color: theme.disabledColor),
                        ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$index',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FullscreenImageViewer extends StatefulWidget {
  const _FullscreenImageViewer({
    required this.paths,
    required this.initialIndex,
    required this.documentId,
  });

  final List<String> paths;
  final int initialIndex;
  final String documentId;

  @override
  State<_FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<_FullscreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.paths.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return FutureBuilder<String>(
                future: _resolvePath(widget.paths[index]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Hero(
                    tag: 'page_${widget.documentId}_${index + 1}',
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Center(
                        child: Image.file(
                          File(snapshot.data!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  if (widget.paths.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${widget.paths.length}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  const SizedBox(width: 48), // Spacer to balance the close button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _resolvePath(String path) async {
    if (path.contains('/') || path.contains('\\')) {
      return path;
    }
    final appDocDir = await getApplicationDocumentsDirectory();
    return p.join(appDocDir.path, path);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
