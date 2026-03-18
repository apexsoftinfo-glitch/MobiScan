import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/navigation/app_navigator.dart';
import '../../../../app/profile/presentation/cubit/account_actions_cubit.dart';
import '../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../cubit/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        BlocProvider<AccountActionsCubit>(
          create: (_) => getIt<AccountActionsCubit>(),
        ),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  late final TextEditingController _firstNameController;
  late final FocusNode _firstNameFocusNode;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _firstNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _firstNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final sharedUser = session.sharedUserOrNull;
    final firstName = sharedUser?.firstName ?? '';
    final l10n = context.l10n;

    if (!_firstNameFocusNode.hasFocus &&
        _firstNameController.text != firstName) {
      _firstNameController.text = firstName;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.successKey == 'profile_saved') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.profileSavedSnackbar)),
              );
              context.read<ProfileCubit>().clearFeedback();
            }
          },
        ),
        BlocListener<AccountActionsCubit, AccountActionsState>(
          listener: (context, state) {
            if (state.successKey == 'pro_enabled') {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.proEnabledSnackbar)));
              context.read<AccountActionsCubit>().clearFeedback();
            }

            if (state.successKey == 'account_deleted') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.accountDeletedSnackbar)),
              );
              context.read<AccountActionsCubit>().clearFeedback();
            }
          },
        ),
      ],
      child: PopScope(
        canPop: !_hasUnsavedChanges(firstName),
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || !_hasUnsavedChanges(firstName)) return;

          final shouldDiscard = await _confirmDiscardChanges(context);
          if (!context.mounted || !shouldDiscard) return;
          Navigator.of(context).pop();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.profileTitle),
              centerTitle: true,
            ),
            body: SafeArea(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  return BlocBuilder<AccountActionsCubit, AccountActionsState>(
                    builder: (context, accountState) {
                      final isSavingName = profileState.isSaving;
                      final activeAction = accountState.activeAction;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Column(
                              children: [
                                _ProfileHeader(
                                  session: session,
                                  isUpdating: isSavingName,
                                ),
                                const SizedBox(height: 32),
                                _ProfileSection(
                                  title: 'Twoje Konto',
                                  children: [
                                    _ProfileCard(
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: _firstNameController,
                                            focusNode: _firstNameFocusNode,
                                            enabled:
                                                !isSavingName &&
                                                activeAction == null,
                                            decoration: InputDecoration(
                                              labelText:
                                                  l10n.firstNameFieldLabel,
                                              prefixIcon: const Icon(
                                                Icons.person_outline,
                                              ),
                                              border: InputBorder.none,
                                              filled: false,
                                            ),
                                            onSubmitted:
                                                (_) => _saveFirstName(
                                                  context,
                                                  session,
                                                ),
                                          ),
                                          if (_hasUnsavedChanges(firstName))
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: FilledButton(
                                                onPressed:
                                                    !isSavingName &&
                                                        activeAction == null
                                                    ? () => _saveFirstName(
                                                      context,
                                                      session,
                                                    )
                                                    : null,
                                                child: isSavingName
                                                    ? _LoadingCircle()
                                                    : Text(
                                                      l10n.saveFirstNameButtonLabel,
                                                    ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (session.isAnonymousUser) ...[
                                      const SizedBox(height: 12),
                                      _ProfileTile(
                                        onTap:
                                            !isSavingName &&
                                                activeAction == null
                                            ? () async {
                                              final r =
                                                  await AppNavigator
                                                      .goToRegister(context);
                                              if (r == true &&
                                                  context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      l10n.accountSecuredSnackbar,
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                            : null,
                                        icon: Icons.security,
                                        title: l10n.registerButtonLabel,
                                        subtitle: 'Zabezpiecz swoje dane',
                                        isPrimary: true,
                                      ),
                                      const SizedBox(height: 12),
                                      _ProfileTile(
                                        onTap:
                                            !isSavingName &&
                                                activeAction == null
                                            ? () => AppNavigator.goToLogin(
                                              context,
                                            )
                                            : null,
                                        icon: Icons.login,
                                        title: l10n.loginButtonLabel,
                                      ),
                                    ],
                                    if (!session.isAnonymousUser) ...[
                                      const SizedBox(height: 12),
                                      _ProfileTile(
                                        onTap:
                                            !isSavingName &&
                                                activeAction == null
                                            ? () => context
                                                .read<AccountActionsCubit>()
                                                .signOut()
                                            : null,
                                        icon: Icons.logout,
                                        title: l10n.logoutButtonLabel,
                                        trailing:
                                            activeAction ==
                                                    AccountAction.signOut
                                                ? _LoadingCircle()
                                                : null,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 32),
                                _ProfileSection(
                                  title: 'Subskrypcja',
                                  children: [
                                    _SubscriptionCard(session: session),
                                    if (!session.isProUser) ...[
                                      const SizedBox(height: 12),
                                      _ProfileTile(
                                        onTap:
                                            !isSavingName &&
                                                activeAction == null &&
                                                session.userIdOrNull != null
                                            ? () => context
                                                .read<AccountActionsCubit>()
                                                .buyPro(session.userIdOrNull!)
                                            : null,
                                        icon: Icons.stars,
                                        title: l10n.buyProButtonLabel,
                                        isPrimary: true,
                                        trailing:
                                            activeAction == AccountAction.buyPro
                                                ? _LoadingCircle()
                                                : null,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 32),
                                _ProfileSection(
                                  title: 'Pozostałe',
                                  children: [
                                    _ProfileTile(
                                      onTap:
                                          !isSavingName && activeAction == null
                                              ? () => _confirmDeleteAccount(
                                                context,
                                              )
                                              : null,
                                      icon: Icons.delete_forever_outlined,
                                      title: l10n.deleteAccountButtonLabel,
                                      isDestructive: true,
                                      trailing:
                                          activeAction ==
                                                  AccountAction.deleteAccount
                                              ? _LoadingCircle()
                                              : null,
                                    ),
                                  ],
                                ),
                                if (profileState.errorKey != null ||
                                    accountState.errorKey != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: SelectableText(
                                      messageForErrorKey(
                                        l10n,
                                        profileState.errorKey ??
                                            accountState.errorKey,
                                      ),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.error,
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
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _hasUnsavedChanges(String firstName) {
    return _firstNameController.text.trim() != firstName.trim();
  }

  Future<bool> _confirmDiscardChanges(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(context.l10n.discardChangesTitle),
            content: Text(context.l10n.discardChangesBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(context.l10n.stayButtonLabel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(context.l10n.discardButtonLabel),
              ),
            ],
          ),
    );

    return result ?? false;
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.deleteAccountDialogTitle),
            content: Text(l10n.deleteAccountDialogBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancelButtonLabel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: Text(l10n.deleteAccountButtonLabel),
              ),
            ],
          ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AccountActionsCubit>().deleteAccount();
    }
  }

  void _saveFirstName(BuildContext context, SessionState session) {
    final userId = session.userIdOrNull;
    if (userId == null) return;

    FocusScope.of(context).unfocus();
    context.read<ProfileCubit>().saveFirstName(
      userId: userId,
      firstName: _firstNameController.text,
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.session, required this.isUpdating});

  final SessionState session;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sharedUser = session.sharedUserOrNull;
    final initials =
        (sharedUser?.firstName?.isNotEmpty ?? false)
            ? sharedUser!.firstName![0].toUpperCase()
            : '?';

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (isUpdating)
              const SizedBox(
                width: 110,
                height: 110,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          session.emailOrNull ?? 'Użytkownik Gość',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (session.isAnonymousUser)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Konto tymczasowe',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isDestructive = false,
    this.isPrimary = false,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool isPrimary;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        isDestructive
            ? theme.colorScheme.error
            : isPrimary
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color:
              isPrimary
                  ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                  : theme.colorScheme.surfaceContainerLow,
          border: Border.all(
            color:
                isPrimary
                    ? theme.colorScheme.primary.withOpacity(0.2)
                    : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing! else const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({required this.session});
  final SessionState session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPro = session.isProUser;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isPro
                  ? [theme.colorScheme.primary, theme.colorScheme.tertiary]
                  : [
                    theme.colorScheme.surfaceContainerHighest,
                    theme.colorScheme.surfaceContainerLow,
                  ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow:
            isPro
                ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
                : null,
      ),
      child: Row(
        children: [
          Icon(
            isPro ? Icons.workspace_premium : Icons.stars_outlined,
            size: 48,
            color: isPro ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPro ? 'MobiScan PRO' : 'MobiScan FREE',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color:
                        isPro
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isPro
                      ? 'Wszystkie funkcje odblokowane'
                      : 'Odblokuj pełną moc skanowania',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        isPro
                            ? theme.colorScheme.onPrimary.withOpacity(0.8)
                            : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
