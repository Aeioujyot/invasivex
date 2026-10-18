import 'package:flutter/material.dart';

import 'classification_profile.dart';

/// A curated, hand-verified entry in the species library — distinct from a
/// live `IdentificationResult`, which comes from the AI and carries confidence.
class Species {
  final String id;
  final String commonName;
  /// Stand-in thumbnail icon until real reference photos are added.
  final IconData icon;
  final String oneLineSummary;
  final ClassificationProfile profile;

  const Species({
    required this.id,
    required this.commonName,
    required this.icon,
    required this.oneLineSummary,
    required this.profile,
  });
}
