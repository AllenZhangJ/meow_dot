import 'package:flutter/material.dart';
import 'package:meow_dot/presentation/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '喵点', // 应用标题
      theme: AppTheme.lightTheme, // 应用浅色主题
      // darkTheme: AppTheme.darkTheme, // 如果实现了深色主题，取消注释
      // themeMode: ThemeMode.system, // 可以根据系统设置切换主题
      debugShowCheckedModeBanner: false, // 隐藏右上角的 Debug 标签
      home: const MyHomePage(), // 初始页面 (暂时用占位符)
      // navigatorKey: GetIt.I<NavigationService>().navigatorKey, // 如果使用导航服务
      // onGenerateRoute: AppRouter.generateRoute, // 如果使用命名路由
    );
  }
}

// 这是一个临时的占位页面，后续会被替换
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('喵点'),
      ),
      body: const Center(
        child: Text('欢迎使用喵点!'),
      ),
    );
  }
}
