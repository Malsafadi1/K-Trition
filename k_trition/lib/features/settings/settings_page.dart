import 'package:flutter/material.dart';

import '../../data/nutrition_repository.dart';
import 'help_support_screen.dart';
import 'meal_history_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    required this.isDarkMode,
    required this.onDarkModeChanged,
    required this.repositoryLoader,
    super.key,
  });

  final bool isDarkMode;
  final Future<void> Function(bool enabled) onDarkModeChanged;
  final Future<NutritionRepository> Function() repositoryLoader;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _orange = Color(0xFFF28C28);
  bool _savingAppearance = false;
  late bool _isDarkMode = widget.isDarkMode;

  @override
  void didUpdateWidget(covariant SettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _isDarkMode = widget.isDarkMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
          color: _orange,
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                _sectionHeading(context, 'Appearance'),
                _settingsCard(
                  context,
                  child: SwitchListTile.adaptive(
                    value: _isDarkMode,
                    onChanged: _savingAppearance ? null : _changeAppearance,
                    secondary: _iconBadge(context, Icons.dark_mode_outlined),
                    title: const Text(
                      'Dark Mode',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      _savingAppearance
                          ? 'Saving your preference…'
                          : 'Use a darker color palette throughout the app',
                    ),
                    activeTrackColor: _orange,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _sectionHeading(context, 'Meal History'),
                _settingsCard(
                  context,
                  child: _navigationTile(
                    context,
                    icon: Icons.receipt_long_outlined,
                    title: 'Meal History',
                    subtitle: 'Browse meals and nutrition you have logged',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => MealHistoryScreen(
                          repositoryLoader: widget.repositoryLoader,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _sectionHeading(context, 'Help & Support'),
                _settingsCard(
                  context,
                  child: _navigationTile(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Frequently asked questions and contact options',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const HelpSupportScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Divider(color: colors.outlineVariant.withValues(alpha: .6)),
                const SizedBox(height: 10),
                Text(
                  'K-Trition',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    letterSpacing: .5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changeAppearance(bool enabled) async {
    setState(() {
      _savingAppearance = true;
      _isDarkMode = enabled;
    });
    try {
      await widget.onDarkModeChanged(enabled);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isDarkMode = widget.isDarkMode);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Could not save your appearance setting: $error')),
        );
    } finally {
      if (mounted) setState(() => _savingAppearance = false);
    }
  }

  static Widget _sectionHeading(BuildContext context, String title) => Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 10),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: .2,
      ),
    ),
  );

  static Widget _settingsCard(BuildContext context, {required Widget child}) =>
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: child,
          ),
        ),
      );

  static Widget _navigationTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    leading: _iconBadge(context, icon),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.chevron_right),
  );

  static Widget _iconBadge(BuildContext context, IconData icon) => Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      color: _orange.withValues(alpha: .14),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Icon(icon, color: _orange, size: 21),
  );
}
