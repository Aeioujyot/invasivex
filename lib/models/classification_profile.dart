import 'threat_level.dart';

/// Full taxonomic + ecological classification profile for a species,
/// shared by both the curated library and live AI identification results.
class ClassificationProfile {
  final String kingdom;
  final String phylum;
  final String taxClass;
  final String order;
  final String family;
  final String genus;
  final String scientificName;

  final String nativeRange;
  final String habitat;

  final bool isInvasive;
  final List<String> invasiveRegions;
  final String invasiveStatusNotes;

  final String ecologicalImpact;
  final String economicImpact;
  final String controlMethods;

  final ThreatLevel threatLevel;

  const ClassificationProfile({
    required this.kingdom,
    required this.phylum,
    required this.taxClass,
    required this.order,
    required this.family,
    required this.genus,
    required this.scientificName,
    required this.nativeRange,
    required this.habitat,
    required this.isInvasive,
    required this.invasiveRegions,
    required this.invasiveStatusNotes,
    required this.ecologicalImpact,
    required this.economicImpact,
    required this.controlMethods,
    required this.threatLevel,
  });

  /// Root to leaf, for display in a profile table.
  List<(String label, String value)> get taxonomyRows => [
        ('Kingdom', kingdom),
        ('Phylum', phylum),
        ('Class', taxClass),
        ('Order', order),
        ('Family', family),
        ('Genus', genus),
        ('Species', scientificName),
      ];
}
