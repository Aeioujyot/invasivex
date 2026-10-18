import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/identification_result.dart';
import '../theme/app_theme.dart';
import '../widgets/profile_sections.dart';

class ResultScreen extends StatelessWidget {
  final IdentificationResult result;
  final Uint8List imageBytes;

  const ResultScreen({super.key, required this.result, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(imageBytes, height: 220, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              if (!result.identified) ...[
                _uncertaintyNotice(scheme),
                const SizedBox(height: 12),
              ],
              Text(
                result.commonName,
                style: TextStyle(color: scheme.primaryText, fontSize: 22, fontWeight: FontWeight.w700),
              ),
              Text(
                result.scientificName,
                style: TextStyle(color: scheme.secondaryText, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surface2,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: scheme.accent.withValues(alpha: 0.12)),
                ),
                child: ConfidenceView(confidence: result.confidence),
              ),
              const SizedBox(height: 14),
              ClassificationProfileSections(profile: result.profile),
              if (result.alternateCandidates.isNotEmpty) ...[
                const SizedBox(height: 14),
                _alternatesSection(scheme),
              ],
              const SizedBox(height: 14),
              SectionCard(
                title: 'Identification Notes',
                icon: Icons.sticky_note_2_outlined,
                child: Text(result.identificationNotes, style: TextStyle(color: scheme.secondaryText, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uncertaintyNotice(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: scheme.warningFill, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.help_outline, color: scheme.warning, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Claude wasn't confident enough to make a firm identification. Treat this as a best guess — see the alternatives and notes below.",
              style: TextStyle(color: scheme.warning, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _alternatesSection(ColorScheme scheme) {
    return SectionCard(
      title: 'Other Possibilities',
      icon: Icons.list_alt,
      child: Column(
        children: [
          for (final candidate in result.alternateCandidates)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(candidate.commonName, style: TextStyle(color: scheme.primaryText, fontWeight: FontWeight.w600)),
                        Text(candidate.scientificName, style: TextStyle(color: scheme.secondaryText, fontSize: 12, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Text(
                    '${(candidate.confidence * 100).round()}%',
                    style: TextStyle(color: scheme.accent, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
