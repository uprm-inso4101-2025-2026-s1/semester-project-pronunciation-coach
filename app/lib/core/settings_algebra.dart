import 'package:flutter/material.dart';

/// ===========================================================================
/// SETTINGS ALGEBRA: (SettingsState, Operations)
///
/// This file implements an algebraic structure for settings management:
/// - Carrier Set A: SettingsState (all possible settings configurations)
/// - Operations Ω: SettingsAlgebra (transformations on the carrier set)
///
/// All operations maintain the invariant: SettingsState → SettingsState
/// ===========================================================================

/// Carrier Set A: All possible settings states
/// Immutable value object representing a settings configuration
abstract class SettingsState {
  const SettingsState();

  // Algebraic properties (values in the carrier set)
  bool get notifications;
  bool get soundEffects;
  ThemeMode get theme;
  Difficulty get difficulty;

  /// Factory method for default settings
  static SettingsState defaultState() => const DefaultSettings();
}

/// Concrete implementation of default settings
class DefaultSettings extends SettingsState {
  const DefaultSettings();

  @override
  bool get notifications => true;

  @override
  bool get soundEffects => true;

  @override
  ThemeMode get theme => ThemeMode.system;

  @override
  Difficulty get difficulty => Difficulty.medium;
}

/// Difficulty levels as algebraic values
enum Difficulty { easy, medium, hard }

/// Operations Ω: Settings transformation functions
/// All operations: SettingsStateⁿ → SettingsState (return carrier set element)
abstract class SettingsAlgebra {
  /// toggleNotifications: SettingsState → SettingsState (1-ary operation)
  SettingsState toggleNotifications(SettingsState current);

  /// changeTheme: SettingsState → ThemeMode → SettingsState (2-ary operation)
  SettingsState changeTheme(SettingsState current, ThemeMode newTheme);

  /// setDifficulty: SettingsState → Difficulty → SettingsState (2-ary operation)
  SettingsState setDifficulty(SettingsState current, Difficulty level);

  /// resetToDefaults: SettingsState → SettingsState (1-ary operation)
  SettingsState resetToDefaults(SettingsState current);

  /// toggleSound: SettingsState → SettingsState (1-ary operation)
  SettingsState toggleSound(SettingsState current);
}

/// Concrete algebra implementation
/// Demonstrates algebraic operations on the carrier set
class SettingsAlgebraImplementation implements SettingsAlgebra {
  @override
  SettingsState toggleNotifications(SettingsState current) {
    return _SettingsWithOverrides(
      base: current,
      notifications: !current.notifications, // Algebraic transformation
    );
  }

  @override
  SettingsState changeTheme(SettingsState current, ThemeMode newTheme) {
    return _SettingsWithOverrides(
      base: current,
      theme: newTheme, // Algebraic transformation with parameter
    );
  }

  @override
  SettingsState setDifficulty(SettingsState current, Difficulty level) {
    return _SettingsWithOverrides(
      base: current,
      difficulty: level, // Algebraic transformation with parameter
    );
  }

  @override
  SettingsState resetToDefaults(SettingsState current) {
    return SettingsState.defaultState(); // Returns algebraic default
  }

  @override
  SettingsState toggleSound(SettingsState current) {
    return _SettingsWithOverrides(
      base: current,
      soundEffects: !current.soundEffects, // Algebraic transformation
    );
  }
}

/// Helper class for immutable modifications
/// Maintains algebraic closure: all results ∈ SettingsState
class _SettingsWithOverrides extends SettingsState {
  final SettingsState _base;
  final bool? _notifications;
  final bool? _soundEffects;
  final ThemeMode? _theme;
  final Difficulty? _difficulty;

  const _SettingsWithOverrides({
    required SettingsState base,
    bool? notifications,
    bool? soundEffects,
    ThemeMode? theme,
    Difficulty? difficulty,
  }) : _base = base,
       _notifications = notifications,
       _soundEffects = soundEffects,
       _theme = theme,
       _difficulty = difficulty;

  @override
  bool get notifications => _notifications ?? _base.notifications;

  @override
  bool get soundEffects => _soundEffects ?? _base.soundEffects;

  @override
  ThemeMode get theme => _theme ?? _base.theme;

  @override
  Difficulty get difficulty => _difficulty ?? _base.difficulty;
}
