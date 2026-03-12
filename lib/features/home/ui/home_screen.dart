import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../l10n/l10n.dart';

import '../../../core/di/injection.dart';
import '../../../core/design/app_design_system.dart';
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
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppDesignSystem.glassEffect(
              child: AppBar(
                title: Text(l10n.homeTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
                actions: [
                  IconButton(
                    onPressed: () => AppNavigator.goToProfile(context),
                    icon: const Icon(Icons.person_outline),
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              // Subtle background gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topRight,
                      radius: 1.5,
                      colors: [
                        AppDesignSystem.primary.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<list_cubit.DocumentListCubit, list_cubit.DocumentListState>(
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppDesignSystem.primary,
                              foregroundColor: Colors.white,
                            ),
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
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: BlocBuilder<scanner_cubit.DocumentScannerCubit, scanner_cubit.DocumentScannerState>(
            builder: (context, state) {
              final isSaving = state is scanner_cubit.Saving;
              return Container(
                decoration: BoxDecoration(
                  gradient: AppDesignSystem.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppDesignSystem.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  onPressed: isSaving ? null : () => context.read<scanner_cubit.DocumentScannerCubit>().startScan(userId),
                  icon: isSaving 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.document_scanner, color: Colors.white),
                  label: Text(
                    isSaving ? l10n.savingLabel : l10n.addScanButtonLabel,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppDesignSystem.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.description_outlined, size: 64, color: AppDesignSystem.primary),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noScansTitle, 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noScansBody, 
              textAlign: TextAlign.center, 
              style: const TextStyle(color: AppDesignSystem.textSecondary, fontSize: 16),
            ),
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
      padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 16, 16, 100),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _DocumentCard(document: doc),
        );
      },
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});
  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigator.goToDocumentDetail(context, document),
      child: AppDesignSystem.glassEffect(
        opacity: 0.05,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppDesignSystem.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.article_rounded, color: AppDesignSystem.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${document.pages.length} stron • ${document.createdAt.toLocal().toString().substring(0, 16)}',
                      style: const TextStyle(color: AppDesignSystem.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppDesignSystem.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
