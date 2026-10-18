import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/identification_result.dart';
import '../services/claude_vision_service.dart';
import '../services/photo_source.dart';
import '../services/species_identifier.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class IdentifyScreen extends StatefulWidget {
  const IdentifyScreen({super.key});

  @override
  State<IdentifyScreen> createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen> {
  Uint8List? _imageBytes;
  String _mediaType = 'image/jpeg';
  bool _isIdentifying = false;
  String? _errorMessage;

  final SpeciesIdentifier _identifier = ClaudeVisionService();

  Future<void> _capture() => _runPicker(PhotoSource.capturePhoto());
  Future<void> _pickFromGallery() => _runPicker(PhotoSource.pickFromGallery());

  Future<void> _runPicker(Future<XFile?> future) async {
    try {
      final file = await future;
      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _mediaType = _guessMediaType(file.name, file.mimeType);
        _errorMessage = null;
      });
    } catch (e) {
      setState(() => _errorMessage = "Couldn't access that photo: $e");
    }
  }

  String _guessMediaType(String name, String? mimeType) {
    if (mimeType != null && mimeType.startsWith('image/')) return mimeType;
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }

  Future<void> _identify() async {
    final bytes = _imageBytes;
    if (bytes == null) return;
    setState(() {
      _isIdentifying = true;
      _errorMessage = null;
    });
    try {
      final IdentificationResult result = await _identifier.identify(
        imageBytes: bytes,
        mediaType: _mediaType,
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultScreen(result: result, imageBytes: bytes)),
      );
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isIdentifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('InvasiveX')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.eco, size: 40, color: scheme.accentStrong),
              const SizedBox(height: 8),
              Text(
                'Identify a Species',
                style: TextStyle(color: scheme.primaryText, fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                "Photograph a plant or animal to find out what it is, where it's from, and whether it's invasive.",
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.secondaryText),
              ),
              const SizedBox(height: 20),
              _photoPreview(scheme),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _capture,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Choose from Library'),
                ),
              ),
              if (_imageBytes != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isIdentifying ? null : _identify,
                    child: _isIdentifying
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Identify Species'),
                  ),
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: scheme.warning),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoPreview(ColorScheme scheme) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.accent.withValues(alpha: 0.15)),
      ),
      clipBehavior: Clip.antiAlias,
      child: _imageBytes != null
          ? Image.memory(_imageBytes!, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_camera_back_outlined, size: 44, color: scheme.accent.withValues(alpha: 0.6)),
                  const SizedBox(height: 8),
                  Text('No photo yet', style: TextStyle(color: scheme.secondaryText)),
                ],
              ),
            ),
    );
  }
}
