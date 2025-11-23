import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents different learning intensity levels with associated properties.
/// 
/// Each pace defines a daily time commitment and has visual representations
/// including display names, icons, and colors.
enum LearningPace {
  casual,
  standard,
  intensive;

  /// Returns the default learning pace (casual)
  static LearningPace get defaultPace => LearningPace.casual;

  /// Returns the next higher intensity pace.
  /// 
  /// If already at the highest intensity (intensive), returns intensive.
  LearningPace next() {
    switch (this) {
      case LearningPace.casual:
        return LearningPace.standard;
      case LearningPace.standard:
        return LearningPace.intensive;
      case LearningPace.intensive:
        return LearningPace.intensive;
    }
  }

  /// Returns the previous lower intensity pace.
  /// 
  /// If already at the lowest intensity (casual), returns casual.
  LearningPace previous() {
    switch (this) {
      case LearningPace.casual:
        return LearningPace.casual;
      case LearningPace.standard:
        return LearningPace.casual;
      case LearningPace.intensive:
        return LearningPace.standard;
    }
  }

  /// Returns the daily time commitment in minutes for this pace.
  int get minutes {
    switch (this) {
      case LearningPace.casual:
        return 5;
      case LearningPace.standard:
        return 15;
      case LearningPace.intensive:
        return 30;
    }
  }

  /// Returns the user-friendly display name for this pace.
  String get displayName {
    switch (this) {
      case LearningPace.casual:
        return "Casual";
      case LearningPace.standard:
        return "Standard";
      case LearningPace.intensive:
        return "Intensive";
    }
  }

  /// Returns a descriptive subtitle showing the daily time commitment.
  String get subtitle => "$minutes minutes/day";

  /// Returns an icon that visually represents this pace.
  IconData get icon {
    switch (this) {
      case LearningPace.casual:
        return Icons.coffee;
      case LearningPace.standard:
        return Icons.access_time;
      case LearningPace.intensive:
        return Icons.flash_on;
    }
  }
}

/// Page widget that displays the pace selection interface.
/// 
/// This page provides a clean, focused interface for users to choose
/// their preferred learning intensity level.
class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pace Selector"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const PaceSelector(),
    );
  }
}

/// Application state manager for learning pace selection.
/// 
/// Manages the currently selected learning pace and provides operations
/// to change it. Persists the selection using SharedPreferences.
class MyAppState extends ChangeNotifier {
  LearningPace _selectedPace = LearningPace.defaultPace;

  /// Returns the currently selected learning pace.
  LearningPace get selectedPace => _selectedPace;

  MyAppState() {
    _loadPace();
  }

  /// Sets a new learning pace and persists the selection.
  /// 
  /// [pace] - The new learning pace to set
  void setPace(LearningPace pace) async {
    _selectedPace = pace;
    notifyListeners();
    _savePace(pace);
  }

  /// Increases the learning pace to the next higher intensity level.
  void incrementPace() {
    setPace(_selectedPace.next());
  }

  /// Decreases the learning pace to the next lower intensity level.
  void decrementPace() {
    setPace(_selectedPace.previous());
  }

  /// Saves the selected pace to persistent storage.
  /// 
  /// [pace] - The learning pace to save
  Future<void> _savePace(LearningPace pace) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedPace", pace.name);
  }

  /// Loads the previously saved pace from persistent storage.
  /// 
  /// If no saved pace is found or an error occurs, defaults to casual pace.
  Future<void> _loadPace() async {
    final prefs = await SharedPreferences.getInstance();
    final paceString = prefs.getString("selectedPace");

    if (paceString != null) {
      try {
        _selectedPace = LearningPace.values.byName(paceString);
      } catch (e) {
        _selectedPace = LearningPace.defaultPace;
      }
      notifyListeners();
    }
  }
}

/// Widget that displays the pace selection interface with interactive controls.
/// 
/// Provides both incremental controls (faster/slower buttons) and direct
/// selection of all available pace options with visual feedback.
class PaceSelector extends StatelessWidget {
  const PaceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Choose Your Learning Pace",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                onPressed: () => appState.decrementPace(),
                icon: const Icon(Icons.remove),
                label: const Text("Slower"),
              ),
              const SizedBox(width: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                onPressed: () => appState.incrementPace(),
                icon: const Icon(Icons.add),
                label: const Text("Faster"),
              ),
            ],
          ),
          for (var pace in LearningPace.values)
            _buildOption(
              context,
              pace: pace,
              selected: appState.selectedPace == pace,
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// Builds an individual pace option card with visual selection state.
  /// 
  /// [context] - The build context
  /// [pace] - The learning pace to display
  /// [selected] - Whether this pace is currently selected
  Widget _buildOption(
    BuildContext context, {
    required LearningPace pace,
    required bool selected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: _getButtonColorBox(pace, selected),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? Colors.transparent : Colors.grey,
          width: 2,
        ),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),
      child: ListTile(
        leading: Icon(pace.icon, color: Colors.black),
        title: Text(
          pace.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(pace.subtitle),
        trailing: selected
            ? Icon(Icons.check_circle, color: Colors.black)
            : null,
        onTap: null,
      ),
    );
  }
}

/// Returns the background color for a pace option based on its type and selection state.
/// 
/// [pace] - The learning pace to get color for
/// [selected] - Whether the pace is currently selected
/// 
/// Returns:
/// - For selected casual: Yellow shade 400
/// - For selected standard: Orange shade 400  
/// - For selected intensive: Red shade 400
/// - For unselected: White
Color _getButtonColorBox(LearningPace pace, bool selected) {
  if (selected) {
    switch (pace) {
      case LearningPace.casual:
        return Colors.yellow.shade400;
      case LearningPace.standard:
        return Colors.orange.shade400;
      case LearningPace.intensive:
        return Colors.red.shade400;
    }
  } else {
    return Colors.white;
  }
}
