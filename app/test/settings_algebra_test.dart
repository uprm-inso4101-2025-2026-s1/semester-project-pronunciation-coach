import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/features/settings/domain/settings_algebra.dart';

void main() {
  group('Settings Algebra Tests', () {
    late SettingsAlgebra algebra;

    setUp(() {
      algebra = SettingsAlgebraImplementation();
    });

    group('Carrier Set Properties', () {
      test('Default state has expected values', () {
        final defaultState = SettingsState.defaultState();

        expect(defaultState.notifications, true);
        expect(defaultState.soundEffects, true);
        expect(defaultState.theme, ThemeMode.system);
        expect(defaultState.difficulty, Difficulty.medium);
      });
    });

    group('Unary Operations (1-ary)', () {
      test('toggleNotifications: State → State', () {
        // Starting with default (notifications = true)
        final initial = SettingsState.defaultState();
        expect(initial.notifications, true);

        // Apply algebraic operation
        final toggled = algebra.toggleNotifications(initial);
        expect(toggled.notifications, false); // Should be inverted

        // Apply again to test consistency
        final toggledAgain = algebra.toggleNotifications(toggled);
        expect(toggledAgain.notifications, true); // Should return to original
      });

      test('toggleSound: State → State', () {
        final initial = SettingsState.defaultState();
        expect(initial.soundEffects, true);

        final toggled = algebra.toggleSound(initial);
        expect(toggled.soundEffects, false);

        final toggledAgain = algebra.toggleSound(toggled);
        expect(toggledAgain.soundEffects, true);
      });

      test('resetToDefaults: State → State', () {
        // Create a state with some non-default values
        final defaultState = SettingsState.defaultState();
        final modified = algebra.toggleNotifications(defaultState);
        expect(modified.notifications, false); // Not default

        // Reset should return to default
        final reset = algebra.resetToDefaults(modified);
        expect(reset.notifications, true); // Back to default
        expect(reset.soundEffects, true);
        expect(reset.theme, ThemeMode.system);
        expect(reset.difficulty, Difficulty.medium);
      });
    });

    group('Binary Operations (2-ary)', () {
      test('changeTheme: State × ThemeMode → State', () {
        final initial = SettingsState.defaultState();
        expect(initial.theme, ThemeMode.system);

        final changed = algebra.changeTheme(initial, ThemeMode.dark);
        expect(changed.theme, ThemeMode.dark);
        // Other properties should remain unchanged
        expect(changed.notifications, initial.notifications);
        expect(changed.soundEffects, initial.soundEffects);
        expect(changed.difficulty, initial.difficulty);
      });

      test('setDifficulty: State × Difficulty → State', () {
        final initial = SettingsState.defaultState();
        expect(initial.difficulty, Difficulty.medium);

        final changed = algebra.setDifficulty(initial, Difficulty.hard);
        expect(changed.difficulty, Difficulty.hard);
        // Other properties should remain unchanged
        expect(changed.notifications, initial.notifications);
        expect(changed.soundEffects, initial.soundEffects);
        expect(changed.theme, initial.theme);
      });
    });

    group('Algebraic Properties', () {
      test('Closure: Operations preserve carrier set', () {
        final initial = SettingsState.defaultState();

        // Apply various operations - all should return SettingsState
        final afterToggle = algebra.toggleNotifications(initial);
        expect(afterToggle, isA<SettingsState>());

        final afterTheme = algebra.changeTheme(afterToggle, ThemeMode.light);
        expect(afterTheme, isA<SettingsState>());

        final afterReset = algebra.resetToDefaults(afterTheme);
        expect(afterReset, isA<SettingsState>());
      });

      test('Composition: Multiple operations compose correctly', () {
        final initial = SettingsState.defaultState();

        // Compose operations: theme → toggle → difficulty → toggle
        final step1 = algebra.changeTheme(initial, ThemeMode.dark);
        expect(step1.theme, ThemeMode.dark);

        final step2 = algebra.toggleNotifications(step1);
        expect(step2.notifications, false);
        expect(step2.theme, ThemeMode.dark); // Previous change preserved

        final step3 = algebra.setDifficulty(step2, Difficulty.easy);
        expect(step3.difficulty, Difficulty.easy);
        expect(step3.notifications, false);
        expect(step3.theme, ThemeMode.dark);

        final step4 = algebra.toggleNotifications(step3);
        expect(step4.notifications, true); // Back to original
        expect(step4.theme, ThemeMode.dark);
        expect(step4.difficulty, Difficulty.easy);
      });

      test('Idempotent operations: toggle toggle = identity', () {
        // Mathematical property: f(f(x)) = x for involutions
        final initial = SettingsState.defaultState();

        final once = algebra.toggleNotifications(initial);
        final twice = algebra.toggleNotifications(once);

        // After two toggles, should be back to original
        expect(twice.notifications, initial.notifications);
        expect(twice.soundEffects, initial.soundEffects);
        expect(twice.theme, initial.theme);
        expect(twice.difficulty, initial.difficulty);
      });
    });

    group('Error Handling & Edge Cases', () {
      test('Operations handle various starting states', () {
        // Test with different initial states
        final darkMode = algebra.changeTheme(
          SettingsState.defaultState(),
          ThemeMode.dark,
        );
        const easyDiff = Difficulty.easy;
        final easyMode = algebra.setDifficulty(darkMode, easyDiff);
        final noSound = algebra.toggleSound(easyMode);

        // Complex state should still be valid SettingsState
        expect(noSound.theme, ThemeMode.dark);
        expect(noSound.difficulty, Difficulty.easy);
        expect(noSound.soundEffects, false);
        expect(noSound.notifications, true); // Default
      });

      // Could add property-based tests here to generate many combinations
    });
  });
}
