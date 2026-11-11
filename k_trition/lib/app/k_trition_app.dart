import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/nutrition_repository.dart';
import '../features/dashboard/dashboard_screen.dart';

class KTritionApp extends StatefulWidget {
  const KTritionApp({required this.repository, super.key});

  final NutritionRepository repository;

  @override
  State<KTritionApp> createState() => _KTritionAppState();
}

class _KTritionAppState extends State<KTritionApp> {
  static const _darkModeKey = 'dark_mode';

  bool _isDarkMode = false;
  Object? _preferenceError;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _isDarkMode = preferences.getBool(_darkModeKey) ?? false;
        _preferenceError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _preferenceError = error);
    }
  }

  Future<void> _setDarkMode(bool enabled) async {
    final previous = _isDarkMode;
    setState(() => _isDarkMode = enabled);
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setBool(_darkModeKey, enabled);
      if (!saved) throw StateError('The appearance preference was not saved.');
    } catch (_) {
      if (mounted) setState(() => _isDarkMode = previous);
      rethrow;
    }
  }

  Future<NutritionRepository> _loadRepository() async => widget.repository;

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFFF28C28);
    final lightScheme = ColorScheme.fromSeed(seedColor: seedColor);
    final darkScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    return MaterialApp(
      title: 'K-Trition',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: lightScheme, useMaterial3: true),
      darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _preferenceError == null
          ? DashboardScreen(
              repository: widget.repository,
              onDarkModeChanged: _setDarkMode,
              repositoryLoader: _loadRepository,
            )
          : _PreferenceErrorScreen(
              error: _preferenceError!,
              onRetry: _loadDarkMode,
            ),
    );
  }
}

class _PreferenceErrorScreen extends StatelessWidget {
  const _PreferenceErrorScreen({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40),
            const SizedBox(height: 12),
            const Text('Unable to load your appearance settings.'),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    ),
  );
}
