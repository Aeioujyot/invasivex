/// How ecologically disruptive a species is judged to be where it is invasive.
enum ThreatLevel {
  low,
  moderate,
  high,
  severe,
  unknown;

  static ThreatLevel fromJson(String value) {
    return ThreatLevel.values.firstWhere(
      (t) => t.name == value,
      orElse: () => ThreatLevel.unknown,
    );
  }

  String get label {
    switch (this) {
      case ThreatLevel.low:
        return 'Low Threat';
      case ThreatLevel.moderate:
        return 'Moderate Threat';
      case ThreatLevel.high:
        return 'High Threat';
      case ThreatLevel.severe:
        return 'Severe Threat';
      case ThreatLevel.unknown:
        return 'Threat Unclear';
    }
  }

  /// 0...1 fill for a simple gauge.
  double get gaugeValue {
    switch (this) {
      case ThreatLevel.low:
        return 0.25;
      case ThreatLevel.moderate:
        return 0.5;
      case ThreatLevel.high:
        return 0.75;
      case ThreatLevel.severe:
        return 1.0;
      case ThreatLevel.unknown:
        return 0.0;
    }
  }
}
