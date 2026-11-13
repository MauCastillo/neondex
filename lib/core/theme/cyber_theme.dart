import 'package:material_ui/material_ui.dart';

import 'cyber_colors.dart';
import 'cyber_shapes.dart';
import 'cyber_text_styles.dart';

class CyberTheme {
  const CyberTheme._();

  static ThemeData buildDarkTheme() {
    const colorScheme = ColorScheme.dark(
      primary: CyberColors.neonCyan,
      onPrimary: CyberColors.voidBlack,
      secondary: CyberColors.neonMagenta,
      onSecondary: CyberColors.textPrimary,
      tertiary: CyberColors.cyberYellow,
      onTertiary: CyberColors.voidBlack,
      error: CyberColors.alertRed,
      onError: CyberColors.textPrimary,
      surface: CyberColors.panelDark,
      onSurface: CyberColors.textPrimary,
      surfaceContainerHighest: CyberColors.panelElevated,
      outline: CyberColors.gridLine,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: CyberColors.voidBlack,
      fontFamily: CyberTextStyles.bodyFont,
      appBarTheme: const AppBarTheme(
        backgroundColor: CyberColors.deepSpace,
        foregroundColor: CyberColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: CyberTextStyles.hudTitle,
      ),
      cardTheme: CardThemeData(
        color: CyberColors.panelDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: CyberShapes.chamfered(
          cut: 12,
          borderColor: CyberColors.neonCyan.withValues(alpha: 0.35),
          borderWidth: 1,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: CyberColors.deepSpace,
        indicatorColor: CyberColors.neonCyan.withValues(alpha: 0.16),
        indicatorShape: CyberShapes.chamfered(
          cut: 8,
          borderColor: CyberColors.neonCyan.withValues(alpha: 0.7),
          borderWidth: 1,
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: CyberTextStyles.displayFont,
            fontSize: 10,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 1.0,
            color: selected ? CyberColors.neonCyan : CyberColors.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? CyberColors.neonCyan : CyberColors.textMuted,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: CyberColors.neonCyan,
          foregroundColor: CyberColors.voidBlack,
          shape: CyberShapes.chamfered(
            cut: 8,
            borderColor: CyberColors.neonCyan,
            borderWidth: 1,
          ),
          textStyle: const TextStyle(
            fontFamily: CyberTextStyles.displayFont,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CyberColors.neonCyan,
          side: const BorderSide(color: CyberColors.neonCyan, width: 1.2),
          shape: CyberShapes.chamfered(
            cut: 8,
            borderColor: CyberColors.neonCyan,
            borderWidth: 1.2,
          ),
          textStyle: const TextStyle(
            fontFamily: CyberTextStyles.displayFont,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CyberColors.panelDark,
        hintStyle: CyberTextStyles.bodyMedium.copyWith(
          color: CyberColors.textMuted,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CyberColors.gridLine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: CyberColors.neonCyan.withValues(alpha: 0.35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: CyberColors.neonCyan, width: 1.5),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: CyberColors.deepSpace,
        surfaceTintColor: Colors.transparent,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: CyberColors.panelElevated,
        contentTextStyle: CyberTextStyles.bodyMedium.copyWith(
          color: CyberColors.textPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: CyberShapes.chamfered(
          cut: 8,
          borderColor: CyberColors.neonCyan,
          borderWidth: 1,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: CyberColors.gridLine,
        thickness: 1,
      ),
    );
  }
}
