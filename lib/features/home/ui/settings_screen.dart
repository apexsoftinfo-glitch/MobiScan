import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../app/theme/theme_cubit.dart';
import '../../../l10n/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
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
                  icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
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
            const SizedBox(height: 32),
            _InfoSection(),
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
