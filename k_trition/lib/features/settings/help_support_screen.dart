import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _orange = Color(0xFFF28C28);
  static const _faqs = [
    (
      'How do I track a meal?',
      'Open the dashboard, enter the food and serving information, then choose Add Food. The current dashboard keeps those entries in its live session.',
    ),
    (
      'Where is meal history stored?',
      'Meals saved through the app’s local nutrition database are available from Settings → Meal History. Data is stored on this device.',
    ),
    (
      'Does Dark Mode stay enabled?',
      'Yes. Your appearance preference is saved on this device and restored the next time you open K-Trition.',
    ),
    (
      'Can I edit my nutrition goals?',
      'Use Edit Goals on the dashboard to set your daily calorie and water targets.',
    ),
  ];

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
          'Help & Support',
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
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              children: [
                Text(
                  'Frequently asked questions',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Material(
                    color: colors.surfaceContainerLow,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Column(
                        children: [
                          for (
                            var index = 0;
                            index < _faqs.length;
                            index++
                          ) ...[
                            ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              childrenPadding: const EdgeInsets.fromLTRB(
                                16,
                                0,
                                16,
                                16,
                              ),
                              iconColor: _orange,
                              collapsedIconColor: colors.onSurfaceVariant,
                              title: Text(
                                _faqs[index].$1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _faqs[index].$2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: colors.onSurfaceVariant,
                                          height: 1.45,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            if (index < _faqs.length - 1)
                              Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                                color: colors.outlineVariant,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Still need a hand?',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.support_agent, color: _orange, size: 28),
                      const SizedBox(height: 10),
                      Text(
                        'Contact Support',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Open an email draft to describe how we can help.',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => _contactSupport(context),
                        icon: const Icon(Icons.email_outlined),
                        label: const Text('Contact Support'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _contactSupport(BuildContext context) async {
    final emailUri = Uri(
      scheme: 'mailto',
      queryParameters: {
        'subject': 'K-Trition support request',
        'body': 'Hi K-Trition team,\n\nI need help with:\n',
      },
    );
    try {
      final opened = await launchUrl(emailUri);
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No email app is available on this device.'),
          ),
        );
      }
    } on PlatformException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email: ${error.message}')),
      );
    }
  }
}
