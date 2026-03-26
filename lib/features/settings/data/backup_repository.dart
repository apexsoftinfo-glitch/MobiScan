import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../documents/data/repositories/document_repository.dart';
import '../../documents/models/document_model.dart';

abstract class BackupRepository {
  Future<String> createBackup(String userId);
  Future<void> restoreFromBackup(File zipFile, String userId);
}

@LazySingleton(as: BackupRepository)
class BackupRepositoryImpl implements BackupRepository {
  BackupRepositoryImpl(this._documentRepository);

  final DocumentRepository _documentRepository;

  @override
  Future<String> createBackup(String userId) async {
    final docs = await _documentRepository.getDocuments(userId);
    final appDocDir = await getApplicationDocumentsDirectory();
    final tempDir = await getTemporaryDirectory();
    final backupId = DateTime.now().millisecondsSinceEpoch;
    final tempBackupPath = p.join(tempDir.path, 'backup_$backupId');
    final backupDir = Directory(tempBackupPath);
    await backupDir.create(recursive: true);

    // 1. Create metadata.json
    final metadata = docs.map((d) => d.toJson()).toList();
    final metadataFile = File(p.join(backupDir.path, 'metadata.json'));
    await metadataFile.writeAsString(jsonEncode(metadata));

    // 2. Copy images
    final imagesDir = Directory(p.join(backupDir.path, 'images'));
    await imagesDir.create();

    for (final doc in docs) {
      for (final page in doc.pages) {
        final sourceFile = File(p.join(appDocDir.path, page.storagePath));
        if (await sourceFile.exists()) {
          await sourceFile.copy(p.join(imagesDir.path, page.storagePath));
        }
      }
    }

    // 3. ZIP content
    final zipPath = p.join(tempDir.path, 'MobiScan_Backup_${DateTime.now().toString().substring(0, 10)}.zip');
    final encoder = ZipFileEncoder();
    encoder.create(zipPath);
    
    // Add metadata.json
    await encoder.addFile(metadataFile);
    
    // Add images directory
    await encoder.addDirectory(imagesDir);
    
    encoder.close();

    // Clean up temp dir
    await backupDir.delete(recursive: true);

    return zipPath;
  }

  @override
  Future<void> restoreFromBackup(File zipFile, String userId) async {
    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory(p.join(tempDir.path, 'restore_${DateTime.now().millisecondsSinceEpoch}'));
    await extractDir.create(recursive: true);

    // 1. Extract ZIP
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(p.join(extractDir.path, filename))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(p.join(extractDir.path, filename)).createSync(recursive: true);
      }
    }

    // 2. Locate metadata.json and images
    File? metadataFile;
    Directory? imagesDir;

    // Check at root
    final rootMetadata = File(p.join(extractDir.path, 'metadata.json'));
    if (await rootMetadata.exists()) {
      metadataFile = rootMetadata;
    }
    
    final rootImages = Directory(p.join(extractDir.path, 'images'));
    if (await rootImages.exists()) {
      imagesDir = rootImages;
    }

    // If not found at root, check if it's nested (which might happen with some encoders)
    if (metadataFile == null) {
      await for (final entity in extractDir.list(recursive: true)) {
        if (entity is File && p.basename(entity.path) == 'metadata.json') {
          metadataFile = entity;
        }
        if (entity is Directory && p.basename(entity.path) == 'images') {
          imagesDir = entity;
        }
      }
    }

    if (metadataFile == null || !await metadataFile.exists()) {
      throw Exception('Invalid backup: metadata.json not found');
    }

    final content = await metadataFile.readAsString();
    final List<dynamic> json = jsonDecode(content);
    final docs = json.map((j) => DocumentModel.fromJson(j as Map<String, dynamic>)).toList();

    // 3. Restore files and records
    final appDocDir = await getApplicationDocumentsDirectory();

    for (final doc in docs) {
      // Create new document for current user
      final newDoc = await _documentRepository.createDocument(userId: userId, name: doc.name);
      
      for (final page in doc.pages) {
        if (imagesDir != null) {
          final sourceImagePath = p.join(imagesDir.path, page.storagePath);
          final sourceImageFile = File(sourceImagePath);
          
          if (await sourceImageFile.exists()) {
            // Copy to app docs dir
            final targetPath = p.join(appDocDir.path, page.storagePath);
            // Don't overwrite if it already exists, or just copy to new unique name?
            // Since we use UUID for local filenames normally, original names should be safe.
            if (!await File(targetPath).exists()) {
              await sourceImageFile.copy(targetPath);
            }
            
            await _documentRepository.addPage(
              documentId: newDoc.id,
              storagePath: page.storagePath,
              pageIndex: page.pageIndex,
            );
          }
        }
      }
    }

    // Clean up
    await extractDir.delete(recursive: true);
  }
}
