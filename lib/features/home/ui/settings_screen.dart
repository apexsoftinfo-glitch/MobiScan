import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../app/theme/theme_cubit.dart';
import '../../../core/design/app_design_system.dart';
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
        title: Text(l10n.settingsTitle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            _SettingsTile(
              icon: Icons.person_outline_rounded,
              label: l10n.settingsProfile,
              onTap: () => AppNavigator.goToProfile(context),
            ),
            const SizedBox(height: 8),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                final isDark = state.themeMode == ThemeMode.dark;
                return _SettingsSwitchTile(
                  icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDesignSystem.cardDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Informacja o danych',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoItem(
                    title: 'Prywatność',
                    body: 'Twoje fizyczne skany nie opuszczają urządzenia bez Twojej wiedzy (np. dopóki ich nie udostępnisz jako PDF).',
                  ),
                  const SizedBox(height: 12),
                  _InfoItem(
                    title: 'Brak synchronizacji',
                    body: 'Jeśli zalogujesz się na innym telefonie, zobaczysz listę skanów, ale nie będziesz mógł podejrzeć obrazów, ponieważ pliki źródłowe zostały na pierwszym telefonie.',
                  ),
                  const SizedBox(height: 12),
                  _InfoItem(
                    title: 'Ryzyko utraty',
                    body: 'Jeśli odinstalujesz aplikację lub wyczyścisz dane, Twoje skany zostaną bezpowrotnie usunięte (chyba że masz kopię zapasową całego telefonu).',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          body,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
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
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppDesignSystem.cardDecoration(
          color: theme.cardTheme.color,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right_rounded,
                  color: theme.iconTheme.color?.withValues(alpha: 0.5), size: 20),
          ],
        ),
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
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: AppDesignSystem.cardDecoration(
        color: theme.cardTheme.color,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
