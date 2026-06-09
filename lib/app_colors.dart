import 'package:flutter/material.dart';

// Удобный геттер для использования в верстке: context.colors.primaryBG
extension AppColorsExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  // Базовые фоны и границы
  final Color primaryBG;
  final Color secondBG;
  final Color thirdBG;
  final Color border;

  // Текстовые цвета
  final Color primaryText;
  final Color secondText;
  final Color disabledText;

  // Интерактивные состояния (общее)
  final Color hover;
  final Color active;

  // Системные и акцентные цвета (одинаковые или адаптированные)
  final Color error;
  final Color success;
  final Color focusOutline;
  final Color accent;
  final Color accentHover;
  final Color accentActive;

  const AppColors({
    required this.primaryBG,
    required this.secondBG,
    required this.thirdBG,
    required this.border,
    required this.primaryText,
    required this.secondText,
    required this.disabledText,
    required this.hover,
    required this.active,
    required this.error,
    required this.success,
    required this.focusOutline,
    required this.accent,
    required this.accentHover,
    required this.accentActive,
  });

  // Палитра для СВЕТЛОЙ темы
  static const light = AppColors(
    primaryBG: Color(0xFFEDEDED),
    secondBG: Color(0xFFE1E1E1),
    thirdBG: Color(0xFFD5D5D5),
    border: Color(0xFFC5C5C5),
    primaryText: Color(0xFF151515),
    secondText: Color(0xFF4F4F4F),
    disabledText: Color(0xFF999999),
    hover: Color(0xFFC0C0C0),
    active: Color(0xFFE0E0E0),
    error: Color(0xFFFF3B30),
    success: Color(0xFF34C759),
    focusOutline: Color(0xFF0A84FF),
    accent: Color(0xFF6C5CE7),
    accentHover: Color(0xFF5A4BD1),
    accentActive: Color(0xFF483CB8),
  );

  // Палитра для ТЕМНОЙ темы
  static const dark = AppColors(
    primaryBG: Color(0xFF121212),
    secondBG: Color(0xFF1E1E1E),
    thirdBG: Color(0xFF2A2A2A),
    border: Color(0xFF3A3A3A),
    primaryText: Color(0xFFEAEAEA),
    secondText: Color(0xFFB0B0B0),
    disabledText: Color(0xFF666666),
    hover: Color(0xFF383838),
    active: Color(0xFF1C1C1C),
    error: Color(0xFFFF3B30), // Общие системные цвета
    success: Color(0xFF34C759),
    focusOutline: Color(0xFF0A84FF),
    accent: Color(0xFF6C5CE7),
    accentHover: Color(0xFF5A4BD1),
    accentActive: Color(0xFF483CB8),
  );

  @override
  AppColors copyWith({
    Color? primaryBG, Color? secondBG, Color? thirdBG, Color? border,
    Color? primaryText, Color? secondText, Color? disabledText,
    Color? hover, Color? active,
    Color? error, Color? success, Color? focusOutline,
    Color? accent, Color? accentHover, Color? accentActive,
  }) {
    return AppColors(
      primaryBG: primaryBG ?? this.primaryBG,
      secondBG: secondBG ?? this.secondBG,
      thirdBG: thirdBG ?? this.thirdBG,
      border: border ?? this.border,
      primaryText: primaryText ?? this.primaryText,
      secondText: secondText ?? this.secondText,
      disabledText: disabledText ?? this.disabledText,
      hover: hover ?? this.hover,
      active: active ?? this.active,
      error: error ?? this.error,
      success: success ?? this.success,
      focusOutline: focusOutline ?? this.focusOutline,
      accent: accent ?? this.accent,
      accentHover: accentHover ?? this.accentHover,
      accentActive: accentActive ?? this.accentActive,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryBG: Color.lerp(primaryBG, other.primaryBG, t)!,
      secondBG: Color.lerp(secondBG, other.secondBG, t)!,
      thirdBG: Color.lerp(thirdBG, other.thirdBG, t)!,
      border: Color.lerp(border, other.border, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondText: Color.lerp(secondText, other.secondText, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      hover: Color.lerp(hover, other.hover, t)!,
      active: Color.lerp(active, other.active, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      focusOutline: Color.lerp(focusOutline, other.focusOutline, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentHover: Color.lerp(accentHover, other.accentHover, t)!,
      accentActive: Color.lerp(accentActive, other.accentActive, t)!,
    );
  }
}
