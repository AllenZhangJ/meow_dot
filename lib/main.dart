import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meow_dot/app/blocs/pin/pin_cubit.dart';
import 'package:meow_dot/core/di/injectable.dart';
import 'package:meow_dot/domain/models/pinned_item.dart';
import 'package:meow_dot/presentation/themes/app_theme.dart';
import 'package:meow_dot/presentation/windows/pinned_text_window.dart';
import 'package:window_manager/window_manager.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

void main(List<String> args) async {
  if (args.isNotEmpty && args.first == 'multi_window') {
    _runSubWindow(args);
  } else {
    await _runMainWindow();
  }
}

void _runSubWindow(List<String> args) {
  final windowId = int.parse(args[1]);
  final Map<String, dynamic> argument;
  try {
    argument = args[2].isEmpty
        ? const {}
        : jsonDecode(args[2]) as Map<String, dynamic>;
  } catch (e) {
    developer.log('Error decoding sub window arguments: $e', name: 'main_sub');
    return;
  }

  final String? windowType = argument['type'] as String?;
  final String itemId = argument['itemId'] as String? ??
      'unknown_${DateTime.now().millisecondsSinceEpoch}';
  final String initialContent = argument['initialContent'] as String? ?? '';
  final double initialOpacity =
      (argument['initialOpacity'] as num?)?.toDouble() ?? 1.0;
  final double? initialWidth = (argument['initialWidth'] as num?)?.toDouble();
  final double? initialHeight = (argument['initialHeight'] as num?)?.toDouble();
  final double? initialPosX = (argument['initialPosX'] as num?)?.toDouble();
  final double? initialPosY = (argument['initialPosY'] as num?)?.toDouble();

  final Size? initialSize = (initialWidth != null && initialHeight != null)
      ? Size(initialWidth, initialHeight)
      : const Size(300, 200);

  final Offset? initialPosition = (initialPosX != null && initialPosY != null)
      ? Offset(initialPosX, initialPosY)
      : const Offset(100, 100);

  Widget windowWidget;

  switch (windowType) {
    case 'pinnedText':
      windowWidget = PinnedTextWindow(
        windowId: windowId,
        itemId: itemId,
        initialContent: initialContent,
        initialOpacity: initialOpacity,
        initialSize: initialSize,
        initialPosition: initialPosition,
      );
      break;
    default:
      windowWidget = Scaffold(
          backgroundColor: Colors.grey[800],
          body: Center(
              child: Text('Unknown window type: $windowType',
                  style: const TextStyle(color: Colors.white))));
  }

  runApp(SubWindowApp(
    windowId: windowId,
    initialOpacity: initialOpacity,
    initialPosition: initialPosition,
    initialSize: initialSize,
    child: windowWidget,
  ));
}

Future<void> _runMainWindow() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<PinCubit>(),
      child: MaterialApp(
        title: '喵点',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
      ),
    );
  }
}

class SubWindowApp extends StatefulWidget {
  final int windowId;
  final double initialOpacity;
  final Offset? initialPosition;
  final Size? initialSize;
  final Widget child;

  const SubWindowApp({
    super.key,
    required this.windowId,
    required this.initialOpacity,
    this.initialPosition,
    this.initialSize,
    required this.child,
  });

  @override
  State<SubWindowApp> createState() => _SubWindowAppState();
}

class _SubWindowAppState extends State<SubWindowApp> {
  late final WindowController _windowController;

  @override
  void initState() {
    super.initState();
    _windowController = WindowController.fromWindowId(widget.windowId);
    _setupWindow();
  }

  void _setupWindow() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _windowController.setFrame(Rect.fromLTWH(
          widget.initialPosition?.dx ?? 100,
          widget.initialPosition?.dy ?? 100,
          widget.initialSize?.width ?? 300,
          widget.initialSize?.height ?? 200,
        ));
        _windowController.show();
        developer.log('Sub window ${widget.windowId} properties set.',
            name: 'SubWindowApp');
      } catch (e) {
        developer.log(
            'Error setting sub window ${widget.windowId} properties: $e',
            name: 'SubWindowApp');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: widget.child,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('喵点主窗口'),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility_off),
            tooltip: '隐藏主窗口',
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('隐藏主窗口功能暂时禁用')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('欢迎使用喵点!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<PinCubit>().addPinnedItem(
                      contentType: PinnedContentType.text,
                      content:
                          '# 测试标题\n\n这是 **Markdown** *文本*。\n\n`代码块`\n\n- 列表项 1\n- 列表项 2',
                      initialSize: const Size(350, 250),
                      initialPosition: const Offset(150, 150),
                      initialOpacity: 0.8,
                    );
              },
              child: const Text('添加置顶文本窗口'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  developer.log('Attempting to show window...',
                      name: 'MyHomePage');
                  await windowManager.show();
                  await windowManager.focus();
                  developer.log('Window show/focus command sent.',
                      name: 'MyHomePage');
                } catch (e, s) {
                  developer.log('Error showing/focusing window',
                      name: 'MyHomePage', error: e, stackTrace: s);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('显示窗口时出错: $e')),
                    );
                  }
                }
              },
              child: const Text('显示主窗口'),
            ),
            const SizedBox(height: 20),
            BlocBuilder<PinCubit, PinState>(
              builder: (context, state) {
                final firstItemId = state.pinnedItems.isNotEmpty
                    ? state.pinnedItems.first.id
                    : null;
                return ElevatedButton(
                  onPressed: firstItemId != null
                      ? () {
                          developer.log(
                              'Attempting to close item $firstItemId from main window',
                              name: 'MyHomePage');
                          context
                              .read<PinCubit>()
                              .removePinnedItem(firstItemId);
                        }
                      : null,
                  child: const Text('关闭第一个置顶项'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
