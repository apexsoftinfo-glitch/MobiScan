import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/backup_repository.dart';

part 'backup_cubit.freezed.dart';

@freezed
sealed class BackupState with _$BackupState {
  const factory BackupState.initial() = Initial;
  const factory BackupState.loading() = Loading;
  const factory BackupState.backupSuccess({required String zipPath}) = BackupSuccess;
  const factory BackupState.restoreSuccess() = RestoreSuccess;
  const factory BackupState.failure({required String errorKey}) = Failure;
}

@injectable
class BackupCubit extends Cubit<BackupState> {
  BackupCubit(this._backupRepository) : super(const BackupState.initial());

  final BackupRepository _backupRepository;

  Future<void> startBackup(String userId) async {
    emit(const BackupState.loading());
    try {
      final zipPath = await _backupRepository.createBackup(userId);
      emit(BackupState.backupSuccess(zipPath: zipPath));
    } catch (e) {
      debugPrint('❌ [BackupCubit] backup error: $e');
      emit(const BackupState.failure(errorKey: 'backup_failed'));
    }
  }

  Future<void> startRestore(String userId) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null || result.files.single.path == null) {
        emit(const BackupState.initial());
        return;
      }

      emit(const BackupState.loading());
      final file = File(result.files.single.path!);
      await _backupRepository.restoreFromBackup(file, userId);
      emit(const BackupState.restoreSuccess());
    } catch (e) {
      debugPrint('❌ [BackupCubit] restore error: $e');
      emit(const BackupState.failure(errorKey: 'restore_failed'));
    }
  }

  void reset() {
    emit(const BackupState.initial());
  }
}
