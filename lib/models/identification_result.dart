import 'classification_profile.dart';
import 'threat_level.dart';

/// A single alternate candidate identification, offered when confidence is low.
class AlternateCandidate {
  final String commonName;
  final String scientificName;
  final double confidence;

  const AlternateCandidate({
    required this.commonName,
    required this.scientificName,
    required this.confidence,
  });

  factory AlternateCandidate.fromJson(Map<String, dynamic> json) {
    return AlternateCandidate(
      commonName: json['commonName'] as String? ?? '',
      scientificName: json['scientificName'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Decoded straight from the backend's JSON response (which itself mirrors
/// Claude's structured output). Field names match the schema in
/// `server/api/identify.ts` exactly — keep them in sync.
class IdentificationResult {
  final bool identified;
  final String commonName;
  final String scientificName;
  /// 0...1
  final double confidence;

  final String kingdom;
  final String phylum;
  final String taxClass;
  final String order;
  final String family;
  final String genus;

  final String nativeRange;
  final String habitat;

  final bool isInvasive;
  final List<String> invasiveRegions;
  final String invasiveStatusNotes;

  final String ecologicalImpact;
  final String economicImpact;
  final String controlMethods;

  final ThreatLevel threatLevel;

  final List<AlternateCandidate> alternateCandidates;
  final String identificationNotes;

  const IdentificationResult({
    required this.identified,
    required this.commonName,
    required this.scientificName,
    required this.confidence,
    required this.kingdom,
    required this.phylum,
    required this.taxClass,
    required this.order,
    required this.family,
    required this.genus,
    required this.nativeRange,
    required this.habitat,
    required this.isInvasive,
    required this.invasiveRegions,
    required this.invasiveStatusNotes,
    required this.ecologicalImpact,
    required this.economicImpact,
    required this.controlMethods,
    required this.threatLevel,
    required this.alternateCandidates,
    required this.identificationNotes,
  });

  factory IdentificationResult.fromJson(Map<String, dynamic> json) {
    return IdentificationResult(
      identified: json['identified'] as bool? ?? false,
      commonName: json['commonName'] as String? ?? 'Unknown',
      scientificName: json['scientificName'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      kingdom: json['kingdom'] as String? ?? '',
      phylum: json['phylum'] as String? ?? '',
      taxClass: json['taxClass'] as String? ?? '',
      order: json['order'] as String? ?? '',
      family: json['family'] as String? ?? '',
      genus: json['genus'] as String? ?? '',
      nativeRange: json['nativeRange'] as String? ?? '',
      habitat: json['habitat'] as String? ?? '',
      isInvasive: json['isInvasive'] as bool? ?? false,
      invasiveRegions: (json['invasiveRegions'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      invasiveStatusNotes: json['invasiveStatusNotes'] as String? ?? '',
      ecologicalImpact: json['ecologicalImpact'] as String? ?? '',
      economicImpact: json['economicImpact'] as String? ?? '',
      controlMethods: json['controlMethods'] as String? ?? '',
      threatLevel: ThreatLevel.fromJson(json['threatLevel'] as String? ?? 'unknown'),
      alternateCandidates: (json['alternateCandidates'] as List<dynamic>? ?? [])
          .map((e) => AlternateCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      identificationNotes: json['identificationNotes'] as String? ?? '',
    );
  }

  ClassificationProfile get profile => ClassificationProfile(
        kingdom: kingdom,
        phylum: phylum,
        taxClass: taxClass,
        order: order,
        family: family,
        genus: genus,
        scientificName: scientificName,
        nativeRange: nativeRange,
        habitat: habitat,
        isInvasive: isInvasive,
        invasiveRegions: invasiveRegions,
        invasiveStatusNotes: invasiveStatusNotes,
        ecologicalImpact: ecologicalImpact,
        economicImpact: economicImpact,
        controlMethods: controlMethods,
        threatLevel: threatLevel,
      );

  String get confidencePercentText => '${(confidence * 100).round()}%';
}
