import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LearningPace {
  casual,
  standard,
  intensive;

  static LearningPace get defaultPace => LearningPace.casual;

  //Operation: get next pace
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

  //Operation: get previous pace
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

  //Operation: get minutes for pace
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

  //Helper: display name
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

  //Helper: subtitle
  String get subtitle => "$minutes minutes/day";

  //Helper: icon
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

class MyAppState extends ChangeNotifier {
  LearningPace _selectedPace = LearningPace.defaultPace;

  LearningPace get selectedPace => _selectedPace;

  MyAppState() {
    _loadPace();
  }

  void setPace(LearningPace pace) async {
    //The algebra operation: replacing one value with another from the carrier set
    _selectedPace = pace;
    notifyListeners();
    _savePace(pace);
  }

  //Operation: increment the pacce
  void incrementPace() {
    setPace(_selectedPace.next());
  }

  //Operation: decrement the pace
  void decrementPace() {
    setPace(_selectedPace.previous());
  }

  Future<void> _savePace(LearningPace pace) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedPace", pace.name);
  }

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

          //Algebraic increment/drecrement controls
        ],
      ),
    );
  }

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
