import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../app/session/presentation/session_localizations.dart';
import '../../../l10n/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            onPressed: () => AppNavigator.goToProfile(context),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<SessionCubit, SessionState>(
          builder: (context, session) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.currentSessionTitle,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 24),
                          SelectableText(
                            l10n.sessionUserId(session.userIdOrNull ?? '-'),
                          ),
                          const SizedBox(height: 12),
                          SelectableText(
                            l10n.sessionAccountType(
                              context.accountTypeLabel(session),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SelectableText(
                            l10n.sessionPlan(context.tierLabel(session.tier)),
                          ),
                          const SizedBox(height: 12),
                          SelectableText(
                            l10n.sessionPro(
                              context.booleanLabel(session.isProUser),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SelectableText(
                            l10n.sessionEmail(session.emailOrNull ?? '-'),
                          ),
                          const SizedBox(height: 12),
                          SelectableText(
                            l10n.sessionDisplayNameValue(
                              context.sessionDisplayName(session),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SelectableText(
                            l10n.sessionFirstName(
                              session.sharedUserOrNull?.firstName ?? '-',
                            ),
                          ),
                          if (kDebugMode) ...[
                            const SizedBox(height: 24),
                            OutlinedButton.icon(
                              onPressed: () =>
                                  AppNavigator.goToDeveloper(context),
                              icon: const Icon(Icons.developer_mode),
                              label: Text(l10n.developerToolsTitle),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
