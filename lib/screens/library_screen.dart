import 'package:flutter/material.dart';

import '../data/species_library.dart';
import '../models/species.dart';
import '../theme/app_theme.dart';
import 'species_detail_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final species = SpeciesLibrary.all;
    return Scaffold(
      appBar: AppBar(title: const Text('Species Library')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "A small, hand-curated set of well-documented invasive species. We'll keep growing this list.",
              style: TextStyle(color: scheme.secondaryText, fontSize: 12),
            ),
            const SizedBox(height: 12),
            for (final item in species) ...[
              _SpeciesRow(species: item),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpeciesRow extends StatelessWidget {
  final Species species;
  const _SpeciesRow({required this.species});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SpeciesDetailScreen(species: species)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: scheme.surface2,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.accent.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: scheme.sageTint.withValues(alpha: 0.5),
              child: Icon(species.icon, color: scheme.accentStrong, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(species.commonName, style: TextStyle(color: scheme.primaryText, fontWeight: FontWeight.w700)),
                  Text(
                    species.profile.scientificName,
                    style: TextStyle(color: scheme.secondaryText, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    species.oneLineSummary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: scheme.secondaryText, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.secondaryText.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}
