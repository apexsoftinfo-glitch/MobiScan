import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../l10n/l10n.dart';

import '../../../core/di/injection.dart';
import '../../documents/presentation/cubit/document_list_cubit.dart' as list_cubit;
import '../../documents/presentation/cubit/document_scanner_cubit.dart' as scanner_cubit;
import '../../documents/models/document_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = context.watch<SessionCubit>().state.userIdOrNull;

    if (userId == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<list_cubit.DocumentListCubit>()..loadDocuments(userId),
        ),
        BlocProvider(
          create: (context) => getIt<scanner_cubit.DocumentScannerCubit>(),
        ),
      ],
      child: BlocListener<scanner_cubit.DocumentScannerCubit, scanner_cubit.DocumentScannerState>(
        listener: (context, state) {
          if (state is scanner_cubit.Success) {
            // Document scanned and saved
          }
          if (state is scanner_cubit.Error) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.errorUnknown)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.homeTitle),
            actions: [
              IconButton(
                onPressed: () => AppNavigator.goToProfile(context),
                icon: const Icon(Icons.person_outline),
              ),
            ],
          ),
          body: BlocBuilder<list_cubit.DocumentListCubit, list_cubit.DocumentListState>(
            builder: (context, state) {
              return switch (state) {
                list_cubit.Success(documents: final docs) => docs.isEmpty
                    ? _NoScansView()
                    : _DocumentsListView(documents: docs),
                list_cubit.Error() => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.errorUnknown),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<list_cubit.DocumentListCubit>().retry(userId),
                        child: Text(l10n.retryButtonLabel),
                      ),
                    ],
                  ),
                ),
                _ => const Center(child: CircularProgressIndicator()),
              };
            },
          ),
          floatingActionButton: BlocBuilder<scanner_cubit.DocumentScannerCubit, scanner_cubit.DocumentScannerState>(
            builder: (context, state) {
              final isSaving = state is scanner_cubit.Saving;
              return FloatingActionButton.extended(
                onPressed: isSaving ? null : () => context.read<scanner_cubit.DocumentScannerCubit>().startScan(userId),
                icon: isSaving 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.document_scanner),
                label: Text(isSaving ? l10n.savingLabel : l10n.addScanButtonLabel),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NoScansView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(l10n.noScansTitle, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(l10n.noScansBody, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _DocumentsListView extends StatelessWidget {
  const _DocumentsListView({required this.documents});
  final List<DocumentModel> documents;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: Text(doc.name),
          subtitle: Text(doc.createdAt.toLocal().toString().substring(0, 16)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => AppNavigator.goToDocumentDetail(context, doc),
        );
      },
    );
  }
}
