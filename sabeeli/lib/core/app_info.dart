/// Facts about this build shown to users and in problem reports.
abstract final class AppInfo {
  static const name = 'Sabeeli';

  /// Keep in step with `version` in pubspec.yaml.
  static const version = '0.0.2 beta';

  static const privacyPolicyUrl =
      'https://github.com/ADez3/sabeeli/blob/main/docs/privacy.md';
  static const sourceUrl = 'https://github.com/ADez3/sabeeli';

  /// Where problem reports go during the beta.
  static const feedbackEmail = 'daky.adez.dev@gmail.com';
}
