import '../models/identification_result.dart';

/// Abstraction over "turn a photo into an `IdentificationResult`" so the
/// backing implementation can be swapped later — e.g. from the Claude Vision
/// backend today to a self-trained on-device model down the line — without
/// touching any screen code.
abstract class SpeciesIdentifier {
  Future<IdentificationResult> identify({required List<int> imageBytes, required String mediaType});
}

class IdentificationException implements Exception {
  final String message;
  const IdentificationException(this.message);

  @override
  String toString() => message;
}
