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

  void _showTopSuccess(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearMaterialBanners();
    messenger.showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: const Color(0xFF4CAF50),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
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

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        messenger.clearMaterialBanners();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final sharedUser = session.sharedUserOrNull;
    final firstName = sharedUser?.firstName ?? '';
    final l10n = context.l10n;
    final theme = Theme.of(context);

    if (!_firstNameFocusNode.hasFocus &&
        _firstNameController.text != firstName) {
      _firstNameController.text = firstName;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.successKey == 'profile_saved') {
              _showTopSuccess(context, l10n.profileSavedSnackbar);
              context.read<ProfileCubit>().clearFeedback();
            }
          },
        ),
        BlocListener<AccountActionsCubit, AccountActionsState>(
          listener: (context, state) {
            if (state.successKey == 'pro_enabled') {
              _showTopSuccess(context, l10n.proEnabledSnackbar);
              context.read<AccountActionsCubit>().clearFeedback();
            }
            if (state.successKey == 'account_deleted') {
              _showTopSuccess(context, l10n.accountDeletedSnackbar);
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
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text(
                l10n.profileTitle.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              centerTitle: false,
              backgroundColor: theme.scaffoldBackgroundColor,
              scrolledUnderElevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(height: 1, color: theme.dividerColor),
              ),
            ),
            body: SafeArea(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  return BlocBuilder<AccountActionsCubit, AccountActionsState>(
                    builder: (context, accountState) {
                      final isSavingName = profileState.isSaving;
                      final activeAction = accountState.activeAction;

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ProfileHeaderBlock(
                              session: session,
                              isUpdating: isSavingName,
                            ),
                            _sectionLabel(context, 'TWOJE KONTO'),
                            _NameField(
                              controller: _firstNameController,
                              focusNode: _firstNameFocusNode,
                              enabled: !isSavingName && activeAction == null,
                              hasChanges: _hasUnsavedChanges(firstName),
                              isSaving: isSavingName,
                              onSave: () => _saveFirstName(context, session),
                            ),
                            if (session.isAnonymousUser) ...[
                              _ProfileActionTile(
                                enabled: !isSavingName && activeAction == null,
                                icon: Icons.security,
                                title: l10n.registerButtonLabel,
                                subtitle: 'Zabezpiecz swoje dane',
                                isPrimary: true,
                                onTap: () async {
                                  final r = await AppNavigator.goToRegister(context);
                                  if (r == true && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.accountSecuredSnackbar),
                                      ),
                                    );
                                  }
                                },
                              ),
                              _ProfileActionTile(
                                enabled: !isSavingName && activeAction == null,
                                icon: Icons.login,
                                title: l10n.loginButtonLabel,
                                onTap: () => AppNavigator.goToLogin(context),
                              ),
                            ],
                            if (!session.isAnonymousUser)
                              _ProfileActionTile(
                                enabled: !isSavingName && activeAction == null,
                                icon: Icons.logout,
                                title: l10n.logoutButtonLabel,
                                trailing: activeAction == AccountAction.signOut
                                    ? const _Spinner()
                                    : null,
                                onTap: () => context
                                    .read<AccountActionsCubit>()
                                    .signOut(),
                              ),
                            const SizedBox(height: 8),
                            _sectionLabel(context, 'SUBSKRYPCJA'),
                            _SubscriptionRow(session: session),
                            if (!session.isProUser)
                              _ProfileActionTile(
                                enabled: !isSavingName &&
                                    activeAction == null &&
                                    session.userIdOrNull != null,
                                icon: Icons.stars_outlined,
                                title: l10n.buyProButtonLabel,
                                isPrimary: true,
                                trailing:
                                    activeAction == AccountAction.buyPro
                                        ? const _Spinner()
                                        : null,
                                onTap: () => context
                                    .read<AccountActionsCubit>()
                                    .buyPro(session.userIdOrNull!),
                              ),
                            const SizedBox(height: 8),
                            _sectionLabel(context, 'POZOSTAŁE'),
                            _ProfileActionTile(
                              enabled: !isSavingName && activeAction == null,
                              icon: Icons.delete_outline,
                              title: l10n.deleteAccountButtonLabel,
                              isDestructive: true,
                              trailing:
                                  activeAction == AccountAction.deleteAccount
                                      ? const _Spinner()
                                      : null,
                              onTap: () => _confirmDeleteAccount(context),
                            ),
                            if (profileState.errorKey != null ||
                                accountState.errorKey != null)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                                child: SelectableText(
                                  messageForErrorKey(
                                    l10n,
                                    profileState.errorKey ??
                                        accountState.errorKey,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 32),
                          ],
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

  Widget _sectionLabel(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Row(
        children: [
          Container(width: 3, height: 12, color: theme.colorScheme.onSurface),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasUnsavedChanges(String firstName) {
    return _firstNameController.text.trim() != firstName.trim();
  }

  Future<bool> _confirmDiscardChanges(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(),
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
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(),
        title: Text(l10n.deleteAccountDialogTitle),
        content: Text(l10n.deleteAccountDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButtonLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              shape: const RoundedRectangleBorder(),
            ),
            onPressed: () => Navigator.of(context).pop(true),
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

// ─── Header block ──────────────────────────────────────────────────────────

class _ProfileHeaderBlock extends StatelessWidget {
  const _ProfileHeaderBlock({required this.session, required this.isUpdating});

  final SessionState session;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sharedUser = session.sharedUserOrNull;
    final initials = (sharedUser?.firstName?.isNotEmpty ?? false)
        ? sharedUser!.firstName![0].toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Monogram square
          Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                color: theme.colorScheme.onSurface,
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: theme.scaffoldBackgroundColor,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              if (isUpdating)
                const Positioned.fill(
                  child: Center(
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.emailOrNull ?? 'Użytkownik Gość',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (session.isAnonymousUser)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'KONTO TYMCZASOWE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
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

// ─── Name field ────────────────────────────────────────────────────────────

class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.hasChanges,
    required this.isSaving,
    required this.onSave,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final bool hasChanges;
  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: l10n.firstNameFieldLabel,
              prefixIcon: Icon(
                Icons.person_outline,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: theme.dividerColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: theme.dividerColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide:
                    BorderSide(color: theme.colorScheme.onSurface, width: 1.5),
              ),
              filled: true,
              fillColor: theme.cardTheme.color,
            ),
            onSubmitted: (_) => onSave(),
          ),
          if (hasChanges)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: !isSaving ? onSave : null,
                  child: isSaving
                      ? const _Spinner()
                      : Text(l10n.saveFirstNameButtonLabel),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Subscription row ──────────────────────────────────────────────────────

class _SubscriptionRow extends StatelessWidget {
  const _SubscriptionRow({required this.session});

  final SessionState session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPro = session.isProUser;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: isPro
          ? BoxDecoration(
              color: theme.colorScheme.onSurface,
              border: Border.all(color: theme.colorScheme.onSurface, width: 1.5),
            )
          : BoxDecoration(
              color: theme.cardTheme.color,
              border: Border.all(color: theme.dividerColor, width: 1.5),
            ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            isPro ? Icons.workspace_premium : Icons.stars_outlined,
            size: 36,
            color: isPro ? theme.scaffoldBackgroundColor : theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPro ? 'MobiScan PRO' : 'MobiScan FREE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: isPro
                      ? theme.scaffoldBackgroundColor
                      : theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                isPro
                    ? 'Wszystkie funkcje odblokowane'
                    : 'Odblokuj pełną moc skanowania',
                style: TextStyle(
                  fontSize: 12,
                  color: isPro
                      ? theme.scaffoldBackgroundColor.withValues(alpha: 0.65)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Action tile ──────────────────────────────────────────────────────────

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.enabled,
    this.subtitle,
    this.isDestructive = false,
    this.isPrimary = false,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isDestructive;
  final bool isPrimary;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return Column(
      children: [
        InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                // Left border accent for primary actions
                if (isPrimary)
                  Container(
                    width: 3,
                    height: 32,
                    color: theme.colorScheme.onSurface,
                    margin: const EdgeInsets.only(right: 12),
                  ),
                Icon(
                  icon,
                  size: 22,
                  color: enabled
                      ? color
                      : color.withValues(alpha: 0.35),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: enabled
                              ? color
                              : color.withValues(alpha: 0.35),
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                    ],
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                    ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: theme.dividerColor, indent: 20, endIndent: 20),
      ],
    );
  }
}

// ─── Spinner ──────────────────────────────────────────────────────────────

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
