/// Where the InvasiveX backend proxy (server/) lives. The Anthropic API key
/// is held there, never in this app — see server/README.md to deploy it.
///
/// Override at build/run time without editing this file:
///   flutter run --dart-define=API_BASE_URL=https://invasivex-api.vercel.app
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
