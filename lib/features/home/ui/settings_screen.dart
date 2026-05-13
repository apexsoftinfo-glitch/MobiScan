import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../app/theme/theme_cubit.dart';
import '../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../core/di/injection.dart';
import '../../settings/presentation/cubit/backup_cubit.dart';
import '../../../l10n/l10n.dart';
import '../../../core/design/app_design_system.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey _backupTileKey = GlobalKey();

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

  void _showLanguageDialog(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ThemeCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: const RoundedRectangleBorder(),
        title: Text(
          l10n.settingsLanguage.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogActionTile(
              icon: Icons.brightness_auto_outlined,
              label: 'System',
              onTap: () {
                cubit.setLocale(null);
                Navigator.of(dialogContext).pop();
              },
            ),
            _DialogActionTile(
              icon: Icons.language,
              label: 'Polski',
              onTap: () {
                cubit.setLocale(const Locale('pl'));
                Navigator.of(dialogContext).pop();
              },
            ),
            _DialogActionTile(
              icon: Icons.language,
              label: 'English',
              onTap: () {
                cubit.setLocale(const Locale('en'));
                Navigator.of(dialogContext).pop();
              },
            ),
            _DialogActionTile(
              icon: Icons.language,
              label: 'Русский',
              onTap: () {
                cubit.setLocale(const Locale('ru'));
                Navigator.of(dialogContext).pop();
              },
            ),
            _DialogActionTile(
              icon: Icons.language,
              label: 'ქართული',
              onTap: () {
                cubit.setLocale(const Locale('ka'));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelButtonLabel.toUpperCase()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => getIt<BackupCubit>(),
      child: BlocListener<BackupCubit, BackupState>(
        listener: (context, state) {
          if (state is BackupSuccess) {
            // Fix: set sharePositionOrigin for iPad/iOS popovers
            final box = _backupTileKey.currentContext?.findRenderObject() as RenderBox?;
            final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;

            Share.shareXFiles(
              [XFile(state.zipPath)],
              subject: l10n.backupSubject,
              text: l10n.backupText,
              sharePositionOrigin: origin,
            );

            _showTopSuccess(context, l10n.backupSuccessMessage);
          }
          if (state is RestoreSuccess) {
            _showTopSuccess(context, l10n.restoreSuccessMessage);
          }
          if (state is Failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.errorWithKey(state.errorKey)),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  l10n.settingsTitle,
                  style: AppDesignSystem.headline(context),
                ),
                backgroundColor: theme.scaffoldBackgroundColor,
                scrolledUnderElevation: 0,
                centerTitle: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Container(
                          decoration: AppDesignSystem.cardDecoration(),
                          child: Column(
                            children: [
                              _SettingsTile(
                                icon: Icons.person_outline,
                                label: l10n.settingsProfile,
                                onTap: () => AppNavigator.goToProfile(context),
                                isFirst: true,
                              ),
                              BlocBuilder<ThemeCubit, ThemeState>(
                                builder: (context, state) {
                                  final currentLocale = state.locale;
                                  String languageName = 'System';
                                  if (currentLocale?.languageCode == 'pl') languageName = 'Polski';
                                  if (currentLocale?.languageCode == 'en') languageName = 'English';
                                  if (currentLocale?.languageCode == 'ru') languageName = 'Русский';
                                  if (currentLocale?.languageCode == 'ka') languageName = 'ქართული';

                                  return _SettingsTile(
                                    icon: Icons.language_outlined,
                                    label: l10n.settingsLanguage,
                                    trailingText: languageName,
                                    onTap: () => _showLanguageDialog(context),
                                  );
                                },
                              ),
                              const _BackupTile(isLast: true),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoSection(),
                      const SizedBox(height: 24),
                      _AboutSection(),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<BackupCubit, BackupState>(
              builder: (context, state) {
                if (state is Loading) {
                  return Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BackupTile extends StatelessWidget {
  const _BackupTile({this.isLast = false});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = context.watch<SessionCubit>().state.userIdOrNull;

    return _SettingsTile(
      // We still use GlobalKey for sharePositionOrigin on iPad
      key: (context.findAncestorStateOfType<_SettingsScreenState>())?._backupTileKey,
      icon: Icons.history_edu_outlined,
      label: l10n.settingsBackupSection,
      onTap: () {
        if (userId == null) return;
        _showBackupOptions(context, userId);
      },
      isLast: isLast,
    );
  }

  void _showBackupOptions(BuildContext context, String userId) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: const RoundedRectangleBorder(),
        title: Text(
          l10n.settingsBackupSection.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DialogActionTile(
              icon: Icons.cloud_upload_outlined,
              label: l10n.settingsCreateBackup,
              onTap: () {
                Navigator.of(dialogContext).pop();
                context.read<BackupCubit>().startBackup(userId);
              },
            ),
            _DialogActionTile(
              icon: Icons.cloud_download_outlined,
              label: l10n.settingsRestoreBackup,
              onTap: () {
                Navigator.of(dialogContext).pop();
                context.read<BackupCubit>().startRestore(userId);
              },
            ),
            const Divider(height: 16),
            Text(
              l10n.settingsBackupHowItWorks,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Color(0xFFCA8A04), // Dark yellow
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.settingsBackupHowItWorksBody,
              style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelButtonLabel.toUpperCase()),
          ),
        ],
      ),
    );
  }
}

class _DialogActionTile extends StatelessWidget {
  const _DialogActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.onSurface),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsDataInfoTitle,
            style: AppDesignSystem.label().copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: AppDesignSystem.cardDecoration(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _InfoItem(
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFF00B894),
                  title: l10n.settingsDataInfoPrivacyTitle,
                  body: l10n.settingsDataInfoPrivacyBody,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Color(0xFFF1F2F6)),
                ),
                _InfoItem(
                  icon: Icons.sync_disabled_outlined,
                  iconColor: const Color(0xFFFAB1A0),
                  title: l10n.settingsDataInfoNoSyncTitle,
                  body: l10n.settingsDataInfoNoSyncBody,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: Color(0xFFF1F2F6)),
                ),
                _InfoItem(
                  icon: Icons.warning_amber_outlined,
                  iconColor: const Color(0xFFFF7675),
                  title: l10n.settingsDataInfoRiskTitle,
                  body: l10n.settingsDataInfoRiskBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                body,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.trailingText,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? const Radius.circular(32) : Radius.zero,
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                if (trailingText != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      trailingText!,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.settingsOtherSection,
            style: AppDesignSystem.label().copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: AppDesignSystem.cardDecoration(),
            child: _SettingsTile(
              icon: Icons.info_outline,
              label: context.l10n.settingsAboutApp,
              onTap: () => _showAboutDialog(context),
              isFirst: true,
              isLast: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(),
        title: const Text(
          'MobiScan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.settingsAboutAppBody,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(width: 2, height: 24, color: const Color(0xFFEF4444)),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APEX',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'Software for business',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.closeButtonLabel.toUpperCase()),
          ),
        ],
      ),
    );
  }
}

