Map<String, dynamic> buildViewedScreenStatement({
  required String userEmail,
  required String screenName,
}) {
  final now = DateTime.now().toUtc().toIso8601String();
  return {
    'actor': {'mbox': 'mailto:$userEmail'},
    'verb': {
      'id': 'http://id.tincanapi.com/verb/viewed',
      'display': {'en-US': 'viewed'}
    },
    'object': {
      'id': 'urn:app:screen:$screenName',
      'definition': {
        'name': {'en-US': screenName},
        'type': 'http://activitystrea.ms/schema/1.0/application'
      }
    },
    'timestamp': now,
    // Optional:
    'context': {
      'platform': 'Flutter',
      'language': 'en-US',
    }
  };
}
