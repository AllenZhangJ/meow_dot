# **喵点 \- 设计文档 (DESIGN\_DOCUMENT.md)**

版本: v2.0  
日期: 2025-04-29

## **1\. 项目概述**

**项目名称:** 喵点 (Meow Dot)

**项目目标:** 开发一款名为“喵点”的 macOS 平台集成工具集，提供截图、置顶、计时器、桌面时钟等常用功能，旨在提升用户日常工作和学习效率，并具备良好的可扩展性。

## **2\. 核心功能模块**

### **2.1. 截图与标注 (Screenshot & Annotation)**

* **触发方式:**  
  * 全局快捷键（可自定义）  
  * 菜单栏图标菜单  
* **截图类型:**  
  * 区域截图  
  * 窗口截图  
  * 全屏截图  
* **截图后操作面板:**  
  * **基础编辑:** 绘制红色矩形框、绘制红色箭头。  
  * **文字识别 (OCR):** 提取选中区域文字、一键复制。  
  * **截图翻译:** 自动/手动选择语言、调用翻译服务、显示原文与译文、一键复制译文。  
  * **输出/保存:** 复制到剪贴板、保存到文件、直接置顶显示（联动置顶功能）。

### **2.2. 置顶显示 (Pin to Top)**

* **触发方式:**  
  * 全局快捷键（可自定义）  
  * 菜单栏图标菜单  
  * 截图后操作选项  
* **置顶内容类型:**  
  * **图片置顶:**  
    * 来源：当前截图、剪贴板图片、选择本地图片文件。  
    * 功能：调整窗口大小、调整透明度、关闭。  
  * **文字置顶:**  
    * 来源：输入文本、剪贴板文本。  
    * 内容格式：支持普通文本 (Plain Text) 和 Markdown 格式。  
    * 渲染切换：提供切换开关，用于在普通文本和 Markdown 渲染模式之间切换。  
    * 功能：编辑文本内容、调整窗口大小、调整透明度、调整字体大小/样式（可选，主要针对普通文本模式）、关闭。

### **2.3. 计时与时钟 (Timer & Clock)**

* **倒计时器 (Countdown Timer):**  
  * **触发方式:** 菜单栏图标菜单、全局快捷键（可选）。  
  * **功能:** 按分钟/小时快速设置、自定义时间（可选）、添加标签、开始/暂停/重置、删除。  
  * **提醒:** 结束时发出系统通知、可选结束提示音。  
  * **界面:** 可在菜单栏显示状态、计时器管理窗口。  
* **桌面时钟 (Desktop Clock):**  
  * **触发方式:** 菜单栏图标菜单。  
  * **功能:** 在桌面上显示一个时钟窗口。  
  * **特性:**  
    * 置顶 (Always on Top)。  
    * 调整大小 (Resizable)。  
    * *(可扩展: 调整时钟样式、颜色、透明度等)*

## **3\. 系统级功能与要求**

* **全局快捷键 (Global Hotkeys):**  
  * 允许用户为核心功能自定义全局快捷键。  
  * 提供快捷键冲突检测与提示。  
* **应用更新 (Application Updates):**  
  * 内置自动/手动更新检查机制。  
  * 新版本提示与更新引导。  
* **菜单栏图标 (Menu Bar Icon):**  
  * 作为应用的主要入口和状态指示。  
  * 点击图标弹出菜单，快速访问各项功能。  
* **设置/偏好设置 (Settings/Preferences):**  
  * 快捷键管理界面。  
  * 更新相关设置（如检查频率）。  
  * 各功能模块的可配置项（如截图默认保存格式/路径、翻译服务配置、置顶默认透明度、时钟默认样式等）。  
  * 开机自启动选项。

## **4\. 技术与架构要求**

* **平台:** macOS  
* **开发框架:** Flutter  
* **架构:** 采用 **领域驱动设计 (DDD)** 思想进行分层。  
* **状态管理:** 使用 **Bloc** / **Cubit**。  
* **性能:** 低系统资源占用，快速响应。  
* **代码风格:** 中文注释（精简），UI 文本为中文。

## **5\. 用户界面与体验 (UI/UX)**

* **设计风格:** 简洁、现代，与 macOS 系统风格协调。遵循定义的 AppTheme。  
* **交互:** 直观易用，减少用户学习成本。  
* **界面语言:** UI 文本为中文。

## **6\. 可扩展性 (Extensibility)**

* 架构设计应易于未来添加新的工具模块（例如：颜色拾取器、二维码生成/识别等）。  
* 定义清晰的模块接口（通过 Domain 层的 Repository 和 Application 层的 Service）。

## **7\. 技术实现方案**

### **7.1. 项目目录结构 (DDD 分层)**

喵点/  
├── lib/  
│   ├── main.dart                 \# 应用入口与 DI 初始化  
│   ├── app/                      \# 应用层 (Application Layer) \- Use Cases/Blocs  
│   │   ├── blocs/                \# BLoCs/Cubits (按功能域划分)  
│   │   │   ├── screenshot/  
│   │   │   ├── pin/  
│   │   │   ├── timer/  
│   │   │   ├── clock/  
│   │   │   ├── settings/  
│   │   │   └── update/           \# 应用更新相关 Bloc  
│   │   └── services/             \# 应用服务 (可选)  
│   ├── domain/                   \# 领域层 (Domain Layer) \- 核心业务逻辑与模型  
│   │   ├── models/               \# 领域模型 (实体, 值对象)  
│   │   ├── repositories/         \# Repository 抽象接口  
│   │   └── services/             \# 领域服务  
│   ├── infrastructure/           \# 基础设施层 (Infrastructure Layer) \- 数据、平台交互实现  
│   │   ├── data\_sources/         \# 数据源实现 (本地/远程)  
│   │   ├── repositories/         \# Repository 实现  
│   │   └── services/             \# 平台/外部服务实现  
│   │       ├── macos\_api/        \# macOS 平台接口调用 (截图, 窗口, 热键, 通知等)  
│   │       ├── translation/      \# 翻译服务实现  
│   │       ├── ocr/              \# OCR 服务实现  
│   │       └── update\_checker/   \# 更新检查服务实现  
│   ├── presentation/             \# 表示层 (Presentation Layer) \- UI  
│   │   ├── pages/                \# 主要页面/屏幕  
│   │   │   ├── settings\_page.dart        \# 设置页面 (包含快捷键、各功能配置、启动项等)  
│   │   │   └── about\_page.dart           \# 关于页面 (可选，显示版本信息、版权等)  
│   │   ├── windows/              \# 独立窗口/悬浮窗 (非标准 Page)  
│   │   │   ├── screenshot\_editor\_window.dart \# 截图编辑/标注窗口 (截图后弹出)  
│   │   │   ├── pinned\_image\_window.dart    \# 置顶图片窗口 (动态创建)  
│   │   │   ├── pinned\_text\_window.dart     \# 置顶文本窗口 (动态创建, 含 Markdown 切换)  
│   │   │   ├── desktop\_clock\_window.dart   \# 桌面时钟窗口 (动态创建)  
│   │   │   └── timer\_list\_window.dart      \# 计时器列表/管理窗口 (可从菜单栏触发)  
│   │   ├── widgets/              \# 可复用的小部件 (按钮, 输入框, 菜单项等)  
│   │   │   ├── common/                   \# 通用基础组件  
│   │   │   └── feature\_specific/         \# 特定功能相关组件 (如计时器显示条)  
│   │   ├── themes/               \# 应用主题 (AppTheme.dart)  
│   │   └── utils/                \# UI 相关工具类 (颜色转换, 尺寸计算等)  
│   └── core/                     \# 核心工具/通用代码  
│       ├── config/               \# 应用配置 (路由 \- 若复杂可引入, DI 注册)  
│       ├── di/                   \# 依赖注入配置 (get\_it setup)  
│       ├── error/                \# 统一错误处理 (Failures, Exceptions)  
│       ├── utils/                \# 通用工具类 (日志, Debouncer/Throttler 等)  
│       └── constants/            \# 应用常量 (API Keys 路径, 默认设置值等)  
├── macos/                      \# macOS 平台特定代码 (原生插件或配置, Info.plist 权限)  
│   └── Runner/  
│       └── Info.plist            \# 配置权限: 屏幕录制(截图), 网络访问(翻译/更新), 通知等  
├── assets/                     \# 静态资源 (图片, 字体, Logo)  
├── test/                       \# 各层单元测试、集成测试、Widget 测试  
├── pubspec.yaml                \# 项目配置文件  
├── README.md                   \# 项目说明  
└── DESIGN\_DOCUMENT.md          \# 本设计文档

### **7.2. 状态管理**

* 全局状态或跨模块共享状态使用 BlocProvider 在较高层级注入。  
* 页面或复杂组件内部状态优先使用 Cubit，逻辑简单时也可考虑 Bloc。  
* 遵循 Bloc 库的最佳实践，分离事件 (Event)、状态 (State) 和业务逻辑 (Bloc/Cubit)。

### **7.3. 建议使用的 Flutter 插件**

* **核心 & 状态管理:**  
  * flutter\_bloc: 实现 Bloc 模式。  
  * equatable: 简化 Bloc/Cubit 状态对象的比较。  
  * get\_it: 服务定位器，用于依赖注入。  
  * injectable: 配合 get\_it 实现依赖注入代码生成。  
* **系统交互 & 功能:**  
  * window\_manager: 管理窗口（置顶、大小、位置）。  
  * system\_tray: 创建和管理菜单栏图标及菜单。  
  * hotkey\_manager: 注册和监听全局快捷键。  
  * desktop\_screenshot / screen\_capturer: 实现截图功能 (可能需要结合 Platform Channels 实现更精细控制，如窗口截图)。  
  * google\_mlkit\_text\_recognition (或 Platform Channels 调用 macOS Vision): 实现 OCR 功能。  
  * http / dio: 发起网络请求（翻译 API, 更新检查）。  
  * flutter\_markdown: 渲染 Markdown 文本。  
  * shared\_preferences: 存储简单的用户偏好设置。  
  * path\_provider: 获取常用文件系统路径。  
  * flutter\_local\_notifications: 发送本地通知（计时器结束提醒）。  
  * package\_info\_plus: 获取应用版本信息（用于更新检查）。  
  * url\_launcher: 打开 URL（如下载新版本）。  
  * flutter\_dotenv (可选): 管理敏感信息如 API Keys。  
* **UI:**  
  * macos\_ui / fluent\_ui (可选): 提供原生 macOS 风格的 UI 组件。  
* **注意:** 对于某些 macOS 特有的精细控制（如特定窗口截图、更底层的窗口管理、复杂的原生交互），可能需要编写 **Platform Channels** 与原生 Swift/Objective-C 代码进行交互，现有插件可能无法完全覆盖所有场景。

### **7.4. 基础配置文件规范 (pubspec.yaml)**

name: meow\_point \# 项目名称 (小写下划线)  
description: A macOS productivity toolkit with screenshot, pin, timer, and clock features. \# 项目描述  
publish\_to: 'none' \# Prevent accidental publishing to pub.dev

version: 1.0.0+1 \# 应用版本号 (遵循 SemVer)

environment:  
  sdk: '\>=3.0.0 \<4.0.0' \# 指定 Dart SDK 版本约束

dependencies:  
  flutter:  
    sdk: flutter

  \# UI & Core  
  cupertino\_icons: ^1.0.2 \# (如果用到 iOS 风格图标)  
  \# macos\_ui: ^latest \# (如果选用)  
  \# fluent\_ui: ^latest \# (如果选用)

  \# State Management & DI  
  flutter\_bloc: ^latest  
  equatable: ^latest  
  get\_it: ^latest  
  injectable: ^latest

  \# Features & System Interaction  
  window\_manager: ^latest  
  system\_tray: ^latest  
  hotkey\_manager: ^latest  
  \# desktop\_screenshot: ^latest \# 或 screen\_capturer  
  \# google\_mlkit\_text\_recognition: ^latest \# (或准备 Platform Channels)  
  http: ^latest  
  flutter\_markdown: ^latest  
  shared\_preferences: ^latest  
  path\_provider: ^latest  
  flutter\_local\_notifications: ^latest  
  package\_info\_plus: ^latest  
  url\_launcher: ^latest  
  \# flutter\_dotenv: ^latest \# (如果需要)

  \# ... 其他依赖 ...

dev\_dependencies:  
  flutter\_test:  
    sdk: flutter  
  flutter\_lints: ^2.0.0 \# 代码规范检查  
  build\_runner: ^latest \# 代码生成器  
  injectable\_generator: ^latest \# DI 代码生成

flutter:  
  uses-material-design: true \# 即使是 macOS 应用，Material 组件有时也需要

  \# Assets (示例)  
  \# assets:  
  \#   \- assets/images/  
  \#   \- assets/icons/

  \# Fonts (示例)  
  \# fonts:  
  \#   \- family: MyCustomFont  
  \#     fonts:  
  \#       \- asset: assets/fonts/MyCustomFont-Regular.ttf  
  \#       \- asset: assets/fonts/MyCustomFont-Bold.ttf  
  \#         weight: 700

* **规范要点:**  
  * 明确 name, description, version, environment。  
  * 按类别组织 dependencies 和 dev\_dependencies。  
  * 使用 ^latest 或指定明确版本号（推荐后者用于稳定性）。  
  * 配置 flutter\_lints 以保证代码质量。  
  * 配置 build\_runner 和相关 \_generator 插件（如 injectable\_generator）。  
  * 在 flutter: 部分声明 assets 和 fonts。

### **7.5. 应用主题 (AppTheme)**

* 应用的主题应定义在 lib/presentation/themes/app\_theme.dart 文件中。  
* 主题颜色和样式应基于 Logo 设计，保持界面风格统一。  
* 以下为推荐的 AppTheme 实现：  
  import 'package:flutter/material.dart';

  /// 定义应用程序的主题数据。  
  class AppTheme {  
    // 私有构造函数，防止实例化。  
    AppTheme.\_();

    // \--- 调色板 (灵感来自喵点 Logo) \---  
    static const Color \_primaryOrange \= Color(0xFFFFA726); // Material Orange 400 \- 近似值  
    static const Color \_onPrimaryWhite \= Color(0xFFFFFFFF);  
    static const Color \_secondaryGrey \= Color(0xFF757575); // Material Grey 600  
    static const Color \_onSecondaryWhite \= Color(0xFFFFFFFF);  
    static const Color \_backgroundLight \= Color(0xFFFAFAFA); // Material Grey 50  
    static const Color \_onBackgroundDark \= Color(0xFF212121); // Material Grey 900  
    static const Color \_surfaceWhite \= Color(0xFFFFFFFF);  
    static const Color \_onSurfaceDark \= Color(0xFF212121); // Material Grey 900  
    static const Color \_errorRed \= Color(0xFFD32F2F); // Material Red 700  
    static const Color \_onErrorWhite \= Color(0xFFFFFFFF);

    // \--- 浅色主题定义 \---  
    static ThemeData get lightTheme {  
      return ThemeData(  
        brightness: Brightness.light,  
        primaryColor: \_primaryOrange,  
        scaffoldBackgroundColor: \_backgroundLight,  
        colorScheme: const ColorScheme(  
          brightness: Brightness.light,  
          primary: \_primaryOrange,  
          onPrimary: \_onPrimaryWhite,  
          secondary: \_secondaryGrey,  
          onSecondary: \_onSecondaryWhite,  
          error: \_errorRed,  
          onError: \_onErrorWhite,  
          background: \_backgroundLight,  
          onBackground: \_onBackgroundDark,  
          surface: \_surfaceWhite,  
          onSurface: \_onSurfaceDark,  
        ),

        // \--- 组件主题 \---  
        appBarTheme: const AppBarTheme(  
          elevation: 0,  
          backgroundColor: \_primaryOrange,  
          foregroundColor: \_onPrimaryWhite,  
          iconTheme: IconThemeData(color: \_onPrimaryWhite),  
          actionsIconTheme: IconThemeData(color: \_onPrimaryWhite),  
        ),  
        textTheme: const TextTheme().apply(  
          bodyColor: \_onBackgroundDark,  
          displayColor: \_onBackgroundDark,  
        ),  
        elevatedButtonTheme: ElevatedButtonThemeData(  
          style: ElevatedButton.styleFrom(  
            backgroundColor: \_primaryOrange,  
            foregroundColor: \_onPrimaryWhite,  
            shape: RoundedRectangleBorder(  
              borderRadius: BorderRadius.circular(8.0),  
            ),  
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),  
          ),  
        ),  
        textButtonTheme: TextButtonThemeData(  
          style: TextButton.styleFrom(  
            foregroundColor: \_primaryOrange,  
            shape: RoundedRectangleBorder(  
              borderRadius: BorderRadius.circular(8.0),  
            ),  
          ),  
        ),  
        outlinedButtonTheme: OutlinedButtonThemeData(  
           style: OutlinedButton.styleFrom(  
             foregroundColor: \_primaryOrange,  
             side: const BorderSide(color: \_primaryOrange, width: 1.5),  
             shape: RoundedRectangleBorder(  
               borderRadius: BorderRadius.circular(8.0),  
             ),  
             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),  
           ),  
        ),  
        inputDecorationTheme: InputDecorationTheme(  
          filled: true,  
          fillColor: \_surfaceWhite,  
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),  
          border: OutlineInputBorder(  
            borderRadius: BorderRadius.circular(8.0),  
            borderSide: BorderSide(color: \_primaryOrange.withOpacity(0.5)),  
          ),  
          enabledBorder: OutlineInputBorder(  
            borderRadius: BorderRadius.circular(8.0),  
            borderSide: BorderSide(color: \_secondaryGrey.withOpacity(0.4)),  
          ),  
          focusedBorder: OutlineInputBorder(  
            borderRadius: BorderRadius.circular(8.0),  
            borderSide: const BorderSide(color: \_primaryOrange, width: 2.0),  
          ),  
          errorBorder: OutlineInputBorder(  
            borderRadius: BorderRadius.circular(8.0),  
            borderSide: const BorderSide(color: \_errorRed, width: 1.5),  
          ),  
          focusedErrorBorder: OutlineInputBorder(  
            borderRadius: BorderRadius.circular(8.0),  
            borderSide: const BorderSide(color: \_errorRed, width: 2.0),  
          ),  
          labelStyle: const TextStyle(color: \_secondaryGrey),  
          hintStyle: TextStyle(color: \_secondaryGrey.withOpacity(0.8)),  
        ),  
        cardTheme: CardTheme(  
          elevation: 1.0,  
          color: \_surfaceWhite,  
          shape: RoundedRectangleBorder(  
            borderRadius: BorderRadius.circular(12.0),  
            side: BorderSide(color: Colors.grey.shade200, width: 1),  
          ),  
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),  
        ),  
        dialogTheme: DialogTheme(  
          backgroundColor: \_surfaceWhite,  
          shape: RoundedRectangleBorder(  
            borderRadius: BorderRadius.circular(12.0),  
          ),  
          titleTextStyle: TextStyle(  
              color: \_onSurfaceDark,  
              fontSize: 18,  
              fontWeight: FontWeight.bold),  
          contentTextStyle: TextStyle(color: \_onSurfaceDark.withOpacity(0.8)),  
        ),  
        tooltipTheme: TooltipThemeData(  
          decoration: BoxDecoration(  
            color: \_secondaryGrey.withOpacity(0.9),  
            borderRadius: BorderRadius.circular(4),  
          ),  
          textStyle: const TextStyle(color: \_onSecondaryWhite),  
        ),  
        pageTransitionsTheme: const PageTransitionsTheme(  
          builders: {  
            TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),  
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),  
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),  
          },  
        ),  
        visualDensity: VisualDensity.adaptivePlatformDensity,  
        // fontFamily: 'YourCustomFont', // 如果添加了自定义字体，请指定  
      );  
    }

    // \--- 深色主题定义 (可选占位符) \---  
    // static ThemeData get darkTheme { ... }  
  }

### **7.6. 其他配置**

* **依赖注入 (core/di/):** 使用 get\_it 和 injectable 配置服务的注册与获取。  
* **应用配置 (core/config/):** 定义常量、API 端点、默认设置等。  
* **.env 文件 (如果使用 flutter\_dotenv):** 存储 API 密钥等敏感信息，并添加到 .gitignore。  
* **macOS 配置 (macos/Runner/Info.plist):** 必须添加用户权限描述，如：  
  * Privacy \- Screen Recording Usage Description: 用于解释为何需要屏幕录制权限（截图功能）。  
  * Privacy \- Network Usage Description (如果需要通过网络请求): 用于解释为何需要网络访问（翻译、更新检查）。  
  * 根据需要添加其他权限，如文件访问等。