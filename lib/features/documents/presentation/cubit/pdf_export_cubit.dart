import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/document_model.dart';

part 'pdf_export_cubit.freezed.dart';

@freezed
sealed class PdfExportState with _$PdfExportState {
  const factory PdfExportState.initial() = Initial;
  const factory PdfExportState.generating() = Generating;
  const factory PdfExportState.success() = Success;
  const factory PdfExportState.error({
    required String errorKey,
  }) = Error;
}

@injectable
class PdfExportCubit extends Cubit<PdfExportState> {
  PdfExportCubit() : super(const PdfExportState.initial());

  Future<void> exportToPdf(DocumentModel document) async {
    if (document.pages.isEmpty) {
      emit(const PdfExportState.error(errorKey: 'no_pages_error'));
      return;
    }

    emit(const PdfExportState.generating());
    try {
      final pdf = pw.Document();
      final appDocDir = await getApplicationDocumentsDirectory();

      for (final page in document.pages) {
        String fullPath = page.storagePath;
        if (!fullPath.contains('/') && !fullPath.contains('\\')) {
          fullPath = p.join(appDocDir.path, page.storagePath);
        }

        final imageFile = File(fullPath);
        if (await imageFile.exists()) {
          final image = pw.MemoryImage(await imageFile.readAsBytes());
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Center(child: pw.Image(image));
              },
            ),
          );
        }
      }

      final output = await getTemporaryDirectory();
      final sanitizedName = document.name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final file = File("${output.path}/$sanitizedName.pdf");
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)], text: document.name);
      
      emit(const PdfExportState.success());
    } catch (e) {
      debugPrint('❌ [PdfExportCubit] export error: $e');
      emit(const PdfExportState.error(errorKey: 'unknown_error'));
    }
  }

  void clearFeedback() {
    emit(const PdfExportState.initial());
  }
}
