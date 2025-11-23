/// Builds an xAPI statement for tracking when a user views a screen.
/// 
/// This helper function creates a standardized xAPI statement following the
/// Experience API specification for screen view tracking. It generates statements
/// that can be sent to a Learning Record Store (LRS) to track user navigation
/// and engagement with different app screens.
/// 
/// [userEmail]: The email address of the user viewing the screen, used to
///              identify the actor in the xAPI statement
/// [screenName]: The name or identifier of the screen being viewed, used to
///               create the activity object in the xAPI statement
/// 
/// Returns a [Map<String, dynamic>] containing a complete xAPI statement
/// with the following structure:
/// - actor: User identification via email
/// - verb: "viewed" action from the TinCan API verb registry
/// - object: Screen activity with name and type definitions
/// - timestamp: UTC ISO 8601 timestamp of the event
/// - context: Platform and language context information
/// 
/// Example Usage:
/// ```dart
/// final statement = buildViewedScreenStatement(
///   userEmail: 'user@example.com',
///   screenName: 'HomeScreen',
/// );
/// await xApiClient.sendStatement(statement);
/// ```
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