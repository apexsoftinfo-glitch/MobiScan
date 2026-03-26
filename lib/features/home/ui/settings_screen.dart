import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../app/theme/theme_cubit.dart';
import '../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../core/di/injection.dart';
import '../../settings/presentation/cubit/backup_cubit.dart';
import '../../../l10n/l10n.dart';

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
              subject: 'MobiScan Backup',
              text: 'Moja kopia zapasowa MobiScan',
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
                  l10n.settingsTitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                backgroundColor: theme.scaffoldBackgroundColor,
                scrolledUnderElevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Divider(height: 1, color: theme.dividerColor),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.person_outline,
                        label: l10n.settingsProfile,
                        onTap: () => AppNavigator.goToProfile(context),
                      ),
                      BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, state) {
                          final isDark = state.themeMode == ThemeMode.dark;
                          return _SettingsSwitchTile(
                            icon: isDark
                                ? Icons.dark_mode_outlined
                                : Icons.light_mode_outlined,
                            label: l10n.settingsDarkMode,
                            value: isDark,
                            onChanged: (value) {
                              context.read<ThemeCubit>().setThemeMode(
                                    value ? ThemeMode.dark : ThemeMode.light,
                                  );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _InfoSection(),
                      const SizedBox(height: 32),
                      const _BackupTile(), // Changed from _BackupSection
                      const SizedBox(height: 32),
                      _AboutSection(),
                      const SizedBox(height: 32),
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
  const _BackupTile();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = context.watch<SessionCubit>().state.userIdOrNull;

    return _SettingsTile(
      // We still use GlobalKey for sharePositionOrigin on iPad
      key: (context.findAncestorStateOfType<_SettingsScreenState>())?._backupTileKey,
      icon: Icons.history_edu_outlined, // Thematic icon: history/documents/backup
      label: l10n.settingsBackupSection.toUpperCase(),
      onTap: () {
        if (userId == null) return;
        _showBackupOptions(context, userId);
      },
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
            const Text(
              'JAK DZIAŁA?',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Color(0xFFCA8A04), // Dark yellow
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kopia zapasowa służy do bezpiecznego przeniesienia wszystkich Twoich danych i obrazów skanów na inny telefon.',
              style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 14,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 10),
              Text(
                'INFORMACJA O DANYCH',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoItem(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF0D9488),
            title: 'Prywatność',
            body:
                'Twoje fizyczne skany nie opuszczają urządzenia bez Twojej wiedzy (np. dopóki ich nie udostępnisz jako PDF).',
          ),
          const SizedBox(height: 12),
          _InfoItem(
            icon: Icons.sync_disabled_outlined,
            iconColor: const Color(0xFFF97316),
            title: 'Brak synchronizacji',
            body:
                'Jeśli zalogujesz się na innym telefonie, zobaczysz listę skanów, ale nie będziesz mógł podejrzeć obrazów, ponieważ pliki źródłowe zostały na pierwszym telefonie.',
          ),
          const SizedBox(height: 12),
          _InfoItem(
            icon: Icons.warning_amber_outlined,
            iconColor: const Color(0xFFEF4444),
            title: 'Ryzyko utraty',
            body:
                'Jeśli odinstalujesz aplikację lub wyczyścisz dane, Twoje skany zostaną bezpowrotnie usunięte (chyba że masz kopię zapasową całego telefonu).',
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
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 22, color: theme.colorScheme.onSurface),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
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

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            children: [
              Container(width: 3, height: 14, color: theme.colorScheme.onSurface),
              const SizedBox(width: 10),
              Text(
                'POZOSTAŁE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        _SettingsTile(
          icon: Icons.info_outline,
          label: 'O aplikacji',
          onTap: () => _showAboutDialog(context),
        ),
      ],
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
            const Text(
              'Profesjonalne narzędzie do skanowania i zarządzania dokumentami PDF bezpośrednio na Twoim telefonie.',
              style: TextStyle(fontSize: 14, height: 1.5),
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
            child: const Text('ZAMKNIJ'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 22, color: theme.colorScheme.onSurface),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeThumbColor: theme.colorScheme.onSurface,
              ),
            ],
          ),
        ),
        Divider(height: 1, color: theme.dividerColor, indent: 20, endIndent: 20),
      ],
    );
  }
}
