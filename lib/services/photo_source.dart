import 'package:image_picker/image_picker.dart';

/// Thin wrapper around `image_picker` that centralizes capture settings
/// (resolution/quality) in one place, the way we'd centralize image prep in
/// a native client. Works on iOS, Android, web, and desktop.
class PhotoSource {
  PhotoSource._();

  static final ImagePicker _picker = ImagePicker();

  /// Downscale target — keeps upload size and token cost reasonable while
  /// staying well within Claude's useful vision resolution.
  static const double _maxDimension = 1568;
  static const int _quality = 85;

  static Future<XFile?> capturePhoto() {
    return _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: _maxDimension,
      maxHeight: _maxDimension,
      imageQuality: _quality,
      preferredCameraDevice: CameraDevice.rear,
    );
  }

  static Future<XFile?> pickFromGallery() {
    return _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: _maxDimension,
      maxHeight: _maxDimension,
      imageQuality: _quality,
    );
  }
}
