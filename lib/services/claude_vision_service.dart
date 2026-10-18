import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/identification_result.dart';
import 'species_identifier.dart';

/// Identifies species from a photo by calling the InvasiveX backend proxy
/// (see server/api/identify.ts), which in turn calls Claude's vision + web
/// search capabilities. The Anthropic API key never touches this app.
class ClaudeVisionService implements SpeciesIdentifier {
  final String baseUrl;
  final http.Client _client;

  ClaudeVisionService({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? AppConfig.apiBaseUrl,
        _client = client ?? http.Client();

  @override
  Future<IdentificationResult> identify({
    required List<int> imageBytes,
    required String mediaType,
  }) async {
    final uri = Uri.parse('$baseUrl/api/identify');

    http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: {'content-type': 'application/json'},
            body: jsonEncode({
              'imageBase64': base64Encode(imageBytes),
              'mediaType': mediaType,
            }),
          )
          .timeout(const Duration(seconds: 120));
    } catch (e) {
      throw IdentificationException('Could not reach the identification server: $e');
    }

    Map<String, dynamic> json;
    try {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw IdentificationException('The server returned an unreadable response.');
    }

    if (response.statusCode != 200) {
      final message = json['error']?.toString() ?? 'Unknown server error (${response.statusCode}).';
      throw IdentificationException(message);
    }

    try {
      return IdentificationResult.fromJson(json);
    } catch (e) {
      throw IdentificationException("Couldn't understand the identification result: $e");
    }
  }
}
