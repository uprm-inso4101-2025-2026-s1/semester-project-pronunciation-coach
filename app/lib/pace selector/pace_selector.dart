import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LearningPace { none, casual, standard, intensive }

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
  LearningPace? selectedPace;

  MyAppState() {
    _loadPace();
  }

  void setPace(LearningPace pace) async {
    selectedPace = pace;
    notifyListeners();
    _savePace(pace);
  }

  Future<void> _savePace(LearningPace pace) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedPace", pace.toString());
  }

  Future<void> _loadPace() async {
    final prefs = await SharedPreferences.getInstance();
    final paceString = prefs.getString("selectedPace");

    if (paceString != null) {
      selectedPace = LearningPace.values.firstWhere(
        (e) => e.toString() == paceString,
        orElse: () => LearningPace.casual,
      );
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
          _buildOption(
            context,
            icon: Icons.coffee,
            title: "Casual",
            subtitle: "5 minutes/day",
            pace: LearningPace.casual,
            selected: appState.selectedPace == LearningPace.casual,
          ),
          _buildOption(
            context,
            icon: Icons.access_time,
            title: "Standard",
            subtitle: "15 minutes/day",
            pace: LearningPace.standard,
            selected: appState.selectedPace == LearningPace.standard,
          ),
          _buildOption(
            context,
            icon: Icons.flash_on,
            title: "Intensive",
            subtitle: "30 minutes/day",
            pace: LearningPace.intensive,
            selected: appState.selectedPace == LearningPace.intensive,
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required LearningPace pace,
    required bool selected,
  }) {
    var appState = context.read<MyAppState>();

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
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: selected
            ? Icon(Icons.check_circle, color: Colors.black)
            : null,
        onTap: () => appState.setPace(pace),
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
      default:
        return Colors.grey.shade200;
    }
  } else {
    return Colors.white;
  }
}
