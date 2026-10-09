import 'package:flutter/material.dart';

/// Starter screen. Replace the roadmap with real daily progress as features land.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const features = [
    'Food database',
    'Log a meal',
    'Calculate calories and macros from quantity',
    'Track water',
    'Set calorie and water goals',
    'View daily progress',
    'Edit and delete previous entries',
    'Persistent local database',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('K-Trition')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Our K-Trition MVP',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const Text('A nutrition tracker for Kalamazoo College students.'),
              const SizedBox(height: 8),
              const Text(
                'Project starter — the features below are planned for our group to build.',
              ),
              const SizedBox(height: 24),
              ...features.map(
                (feature) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.radio_button_unchecked),
                    title: Text(feature),
                    subtitle: const Text('Planned'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
