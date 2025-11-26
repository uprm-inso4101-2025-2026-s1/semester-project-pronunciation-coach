class XApiStatementBuilder {
  // Private constants (encapsulation)
  static const String _verbViewed = 'http://id.tincanapi.com/verb/viewed';
  static const String _activityType =
      'http://activitystrea.ms/schema/1.0/application';
  static const String _platform = 'Flutter';
  static const String _language = 'en-US';

  const XApiStatementBuilder();

  /// Builds the "viewed screen" xAPI statement
  Map<String, dynamic> buildViewedScreen({
    required String userEmail,
    required String screenName,
  }) {
    if (userEmail.isEmpty) {
      throw ArgumentError('userEmail cannot be empty.');
    }
    if (screenName.isEmpty) {
      throw ArgumentError('screenName cannot be empty.');
    }

    final now = DateTime.now().toUtc().toIso8601String();

    return {
      'actor': {
        'mbox': 'mailto:$userEmail',
      },
      'verb': {
        'id': _verbViewed,
        'display': {'en-US': 'viewed'},
      },
      'object': {
        'id': 'urn:app:screen:$screenName',
        'definition': {
          'name': {'en-US': screenName},
          'type': _activityType,
        }
      },
      'timestamp': now,
      
      'context': {
        'platform': _platform,
        'language': _language,
      }
    };
  }
}
