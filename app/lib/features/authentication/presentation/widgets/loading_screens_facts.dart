class PronunciationFacts {
  /// ===========================================================================
/// PRONUNCIATION FACTS DATABASE
/// ===========================================================================
/// 
/// PURPOSE:
/// - Provides educational content during loading screens
/// - Enhances user engagement with pronunciation tips
/// - Supports learning even during waiting periods
/// 
/// CONTENT:
/// - Collection of 20 English pronunciation facts and tips
/// - Covers various aspects of phonetics and speech patterns
/// - Educational content relevant to language learning app
/// 
/// USAGE:
/// - Random fact selection for variety
/// - Displayed alongside loading animations
/// ===========================================================================
/// 
/// Collection of pronunciation facts and tips
  static final List<String> facts = [
    "The 'th' sound is one of the most difficult for English learners",
    "English has 44 different phonemes (speech sounds)",
    "The schwa sound /ə/ is the most common vowel in English",
    "Word stress can change the meaning of words like 'record' and 'present'",
    "Connected speech makes native speakers sound more fluent",
    "The 'r' sound is pronounced differently in American vs British English",
    "Intonation patterns convey emotion and meaning in sentences",
    "Minimal pairs help distinguish similar sounds like 'ship' and 'sheep'",
    "The past tense '-ed' ending has three different pronunciations",
    "Linking words together improves speech flow and natural rhythm",
    "Vowel length can distinguish words like 'beat' and 'bit'",
    "English is a stress-timed language, unlike syllable-timed languages",
    "The 'ng' sound /ŋ/ only appears at the end of syllables in English",
    "Reduced forms like 'gonna' and 'wanna' are common in casual speech",
    "Pitch changes can turn statements into questions without changing words",
    "The 'h' sound is often dropped in connected speech",
    "English has more vowel sounds than many other languages",
    "Consonant clusters can be challenging for speakers of certain languages",
    "The 's' at the end of words can sound like /s/ or /z/ depending on context",
    "Thought groups help organize speech into meaningful chunks"
  ];

  /// Get a random pronunciation fact from the collection
  static String getRandomFact() {
    final random = DateTime.now().millisecondsSinceEpoch % facts.length;
    return facts[random];
  }
}