import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import BlocProvider
import 'package:get_it/get_it.dart'; // Import GetIt
import 'package:meow_dot/app/blocs/pin/pin_cubit.dart'; // Import PinCubit
import 'package:meow_dot/core/di/injectable.dart';
import 'package:meow_dot/domain/models/pinned_item.dart';
import 'package:meow_dot/presentation/themes/app_theme.dart'; // Corrected import path

Future<void> main() async {
  // Make main async
  // Ensure Flutter bindings are initialized (needed for async operations before runApp)
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependencies using GetIt and injectable
  await configureDependencies();

  // TODO: Add other initializations like window_manager, system_tray etc. here
  // Example:
  // await windowManager.ensureInitialized();
  // await SystemTrayManager.instance.init(); // Assuming you create such a manager

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide PinCubit to the entire application using BlocProvider.
    // We fetch the instance from GetIt, which was registered via @lazySingleton.
    return BlocProvider(
      create: (context) => GetIt.instance<PinCubit>(),
      child: MaterialApp(
        title: '喵点',
        theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        // themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(), // Initial page (placeholder)
        // navigatorKey: GetIt.I<NavigationService>().navigatorKey,
        // onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

// Temporary placeholder page
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('喵点'),
      ),
      body: Center(
        child: Column(
          // Use Column for button
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('欢迎使用喵点!'),
            const SizedBox(height: 20),
            // Add a button to test adding a pinned item
            ElevatedButton(
              onPressed: () {
                // Access PinCubit and add a test item
                context.read<PinCubit>().addPinnedItem(
                      contentType: PinnedContentType.text,
                      content:
                          '# 测试标题\n\n这是 **Markdown** *文本*。\n\n`代码块`\n\n- 列表项 1\n- 列表项 2',
                      // Provide initial size/position if desired
                      // initialSize: const Size(300, 200),
                    );
                // IMPORTANT: This only updates the state.
                // We still need window manager integration to SHOW the window.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('文本置顶项已添加到状态 (窗口未显示)')),
                );
              },
              child: const Text('添加测试置顶文本'),
            ),
          ],
        ),
      ),
    );
  }
}
