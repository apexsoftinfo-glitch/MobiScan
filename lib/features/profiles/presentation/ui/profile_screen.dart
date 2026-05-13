import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/navigation/app_navigator.dart';
import '../../../../app/profile/presentation/cubit/account_actions_cubit.dart';
import '../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../cubit/profile_cubit.dart';
import '../../../../core/design/app_design_system.dart';

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
            child: Text(
              context.l10n.okButtonLabel.toUpperCase(),
              style: const TextStyle(
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
            if (state.successKey == 'password_updated') {
              _showTopSuccess(context, l10n.passwordUpdatedSnackbar);
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
                l10n.profileTitle,
                style: AppDesignSystem.headline(context),
              ),
              centerTitle: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              scrolledUnderElevation: 0,
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
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                l10n.profileSectionAccount,
                                style: AppDesignSystem.label().copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                decoration: AppDesignSystem.cardDecoration(),
                                child: Column(
                                  children: [
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
                                        subtitle: l10n.profileSecureDataSubtitle,
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
                                        isLast: true,
                                      ),
                                    ],
                                    if (!session.isAnonymousUser) ...[
                                      _ProfileActionTile(
                                        enabled: !isSavingName && activeAction == null,
                                        icon: Icons.lock_outline,
                                        title: l10n.changePasswordButtonLabel,
                                        trailing: activeAction ==
                                                AccountAction.updatePassword
                                            ? const _Spinner()
                                            : null,
                                        onTap: () => _showChangePasswordDialog(context),
                                      ),
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
                                        isLast: true,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                l10n.profileSectionOther,
                                style: AppDesignSystem.label().copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                decoration: AppDesignSystem.cardDecoration(),
                                child: _ProfileActionTile(
                                  enabled: !isSavingName && activeAction == null,
                                  icon: Icons.delete_outline,
                                  title: l10n.deleteAccountButtonLabel,
                                  isDestructive: true,
                                  isLast: true,
                                  trailing:
                                      activeAction == AccountAction.deleteAccount
                                          ? const _Spinner()
                                          : null,
                                  onTap: () => _confirmDeleteAccount(context),
                                ),
                              ),
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
                            const SizedBox(height: 48),
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

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final cubit = context.read<AccountActionsCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(),
        title: Text(l10n.changePasswordDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.changePasswordDialogBody,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.newPasswordFieldLabel,
                border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.changePasswordButtonLabel),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.trim().length >= 6) {
      cubit.updatePassword(controller.text.trim());
    } else if (confirmed == true) {
      // Show error or just don't close if validation fails
      // For now we just don't call update if < 6
    }
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
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppDesignSystem.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppDesignSystem.accent.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              if (isUpdating)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.emailOrNull ?? context.l10n.profileGuestUserLabel,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                if (session.isAnonymousUser)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        context.l10n.profileTemporaryAccountLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              labelText: l10n.firstNameFieldLabel,
              prefixIcon: Icon(
                Icons.person_outline,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.dividerColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.dividerColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: AppDesignSystem.accent, width: 2),
              ),
              filled: true,
              fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.02),
            ),
            onSubmitted: (_) => onSave(),
          ),
          if (hasChanges)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: !isSaving ? onSave : null,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
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
    this.isLast = false,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isDestructive;
  final bool isPrimary;
  final bool isLast;
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
          borderRadius: BorderRadius.vertical(
            bottom: isLast ? const Radius.circular(32) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? theme.colorScheme.error.withValues(alpha: 0.1)
                        : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: enabled ? color : color.withValues(alpha: 0.35),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: enabled ? color : color.withValues(alpha: 0.35),
                          letterSpacing: -0.3,
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
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    ),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Color(0xFFF1F2F6)),
          ),
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
