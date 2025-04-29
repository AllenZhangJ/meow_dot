/**
 * 日期: 2025/4/29
 * 文件: app_theme
 * 包名: presentation.themes
 * 用户: allenaaron
 */

import 'package:flutter/material.dart';

/// 定义应用程序的主题数据。
class AppTheme {
  // 私有构造函数，防止实例化。
  AppTheme._();

  // --- 调色板 (灵感来自喵点 Logo - 假设 Logo 主色调为橙色) ---
  static const Color _primaryOrange =
      Color(0xFFFFA726); // Material Orange 400 - 近似值
  static const Color _onPrimaryWhite = Color(0xFFFFFFFF);
  static const Color _secondaryGrey = Color(0xFF757575); // Material Grey 600
  static const Color _onSecondaryWhite = Color(0xFFFFFFFF);
  static const Color _backgroundLight = Color(0xFFFAFAFA); // Material Grey 50
  static const Color _onBackgroundDark = Color(0xFF212121); // Material Grey 900
  static const Color _surfaceWhite = Color(0xFFFFFFFF);
  static const Color _onSurfaceDark = Color(0xFF212121); // Material Grey 900
  static const Color _errorRed = Color(0xFFD32F2F); // Material Red 700
  static const Color _onErrorWhite = Color(0xFFFFFFFF);

  // --- 浅色主题定义 ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: _primaryOrange,
      scaffoldBackgroundColor: _backgroundLight,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: _primaryOrange,
        onPrimary: _onPrimaryWhite,
        secondary: _secondaryGrey,
        onSecondary: _onSecondaryWhite,
        error: _errorRed,
        onError: _onErrorWhite,
        background: _backgroundLight,
        onBackground: _onBackgroundDark,
        surface: _surfaceWhite,
        onSurface: _onSurfaceDark,
      ),

      // --- 组件主题 ---
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: _primaryOrange,
        foregroundColor: _onPrimaryWhite,
        // 用于标题和图标颜色
        iconTheme: IconThemeData(color: _onPrimaryWhite),
        actionsIconTheme: IconThemeData(color: _onPrimaryWhite),
        titleTextStyle: TextStyle(
          // 明确定义标题样式
          color: _onPrimaryWhite,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: const TextTheme().apply(
        // 基础文本颜色
        bodyColor: _onBackgroundDark,
        displayColor: _onBackgroundDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryOrange, // 背景色
          foregroundColor: _onPrimaryWhite, // 前景色 (文字/图标)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryOrange, // 前景色 (文字/图标)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryOrange, // 前景色 (文字/图标)
          side: const BorderSide(color: _primaryOrange, width: 1.5), // 边框
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        border: OutlineInputBorder(
          // 默认边框
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              BorderSide(color: _secondaryGrey.withOpacity(0.4)), // 使用较浅的灰色
        ),
        enabledBorder: OutlineInputBorder(
          // 可用状态边框
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: _secondaryGrey.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          // 聚焦状态边框
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: _primaryOrange, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          // 错误状态边框
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: _errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // 聚焦错误状态边框
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: _errorRed, width: 2.0),
        ),
        labelStyle: const TextStyle(color: _secondaryGrey),
        // 标签文字颜色
        hintStyle: TextStyle(color: _secondaryGrey.withOpacity(0.8)), // 提示文字颜色
      ),
      cardTheme: CardTheme(
        elevation: 1.0,
        color: _surfaceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.grey.shade200, width: 1), // 添加细边框
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: _surfaceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        titleTextStyle: TextStyle(
            color: _onSurfaceDark, fontSize: 18, fontWeight: FontWeight.bold),
        contentTextStyle: TextStyle(color: _onSurfaceDark.withOpacity(0.8)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: _secondaryGrey.withOpacity(0.9), // 使用灰色背景
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(color: _onSecondaryWhite), // 白色文字
      ),
      // macOS 平台过渡动画 (如果需要更原生的感觉，可以研究 macos_ui 包提供的)
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          // 为 macOS 提供一个简单的淡入淡出效果，或者保持默认
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          // 其他平台可以保持或自定义
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          // iOS 使用 Cupertino 风格
        },
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity, // 适应平台密度
      // fontFamily: 'YourCustomFont', // 如果添加了自定义字体，请在此指定
    );
  }

// --- 深色主题定义 (可选占位符，可以后续实现) ---
// static ThemeData get darkTheme {
//   // ... 深色主题的实现 ...
// }
}
