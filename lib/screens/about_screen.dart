import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Icon(Icons.eco, size: 40, color: scheme.accentStrong),
            const SizedBox(height: 12),
            Text('InvasiveX', style: TextStyle(color: scheme.primaryText, fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _paragraph(
              scheme,
              'How identification works',
              "InvasiveX sends your photo to Claude, Anthropic's AI model, which identifies the species, searches the web to verify facts about it, and returns its native range, invasive status, and ecological impact. The Anthropic API key lives only on our backend server — never on this device.",
            ),
            const SizedBox(height: 16),
            _paragraph(
              scheme,
              'Accuracy',
              "AI identification isn't perfect, especially for look-alike species or unusual photo angles. Check the confidence score and alternate candidates on each result, and treat uncertain identifications as a starting point for your own research rather than a final answer.",
            ),
            const SizedBox(height: 16),
            _paragraph(
              scheme,
              'Species library',
              "The library tab has a small, hand-curated set of well-documented invasive species that we verified directly — it will keep growing.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _paragraph(ColorScheme scheme, String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: scheme.primaryText, fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 4),
        Text(body, style: TextStyle(color: scheme.secondaryText, fontSize: 13, height: 1.4)),
      ],
    );
  }
}
