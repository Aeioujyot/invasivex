import 'package:flutter/material.dart';

import '../models/species.dart';
import '../theme/app_theme.dart';
import '../widgets/profile_sections.dart';

class SpeciesDetailScreen extends StatelessWidget {
  final Species species;
  const SpeciesDetailScreen({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(species.commonName)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: scheme.sageTint.withValues(alpha: 0.5),
                    child: Icon(species.icon, color: scheme.accentStrong, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(species.commonName, style: TextStyle(color: scheme.primaryText, fontSize: 20, fontWeight: FontWeight.w700)),
                        Text(
                          species.profile.scientificName,
                          style: TextStyle(color: scheme.secondaryText, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(species.oneLineSummary, style: TextStyle(color: scheme.secondaryText)),
              const SizedBox(height: 16),
              ClassificationProfileSections(profile: species.profile),
            ],
          ),
        ),
      ),
    );
  }
}
