import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../models/document_model.dart';

class DocumentThumbnail extends StatelessWidget {
  const DocumentThumbnail({super.key, required this.document, this.size = 44.0});

  final DocumentModel document;
  final double size;

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
                      ? ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            1.2, 0, 0, 0, -25.6,
                            0, 1.2, 0, 0, -25.6,
                            0, 0, 1.2, 0, -25.6,
                            0, 0, 0, 1, 0,
                          ]),
                          child: Image.file(file, fit: BoxFit.cover),
                        )
                      : Icon(
                          Icons.article_outlined,
                          size: size * 0.5,
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
