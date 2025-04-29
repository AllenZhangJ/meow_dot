import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'dart:developer' as developer;

class PinnedTextWindow extends StatefulWidget {
  final int windowId;
  final String itemId;
  final String initialContent;
  final double initialOpacity;
  final Size? initialSize;
  final Offset? initialPosition;

  const PinnedTextWindow({
    super.key,
    required this.windowId,
    required this.itemId,
    required this.initialContent,
    this.initialOpacity = 1.0,
    this.initialSize,
    this.initialPosition,
  });

  @override
  State<PinnedTextWindow> createState() => _PinnedTextWindowState();
}

class _PinnedTextWindowState extends State<PinnedTextWindow> {
  bool _isEditing = false;
  bool _showMarkdown = true;
  late TextEditingController _textEditingController;
  late double _currentOpacity;

  late final WindowController _windowController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialContent);
    _currentOpacity = widget.initialOpacity;
    _initializeWindow();
  }

  void _initializeWindow() {
    try {
      _windowController = WindowController.fromWindowId(widget.windowId);
      DesktopMultiWindow.setMethodHandler(_handleHostMethod);

      DesktopMultiWindow.invokeMethod(
        0,
        'windowCreated',
        {'itemId': widget.itemId, 'windowId': widget.windowId},
      );
      setState(() {
        _isInitialized = true;
      });
      developer.log(
          'Initialized WindowController for ID: ${widget.windowId} (Item ${widget.itemId})',
          name: 'PinnedTextWindow');
    } catch (e) {
      developer.log(
          'Error initializing WindowController for item ${widget.itemId}.',
          name: 'PinnedTextWindow',
          error: e);
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  Future<dynamic> _handleHostMethod(MethodCall call, int fromWindowId) async {
    developer.log(
        'PinnedTextWindow (${widget.itemId}) received host method: ${call.method} from $fromWindowId',
        name: 'PinnedTextWindow');
    final Map<String, dynamic> argsMap =
        call.arguments is Map ? Map<String, dynamic>.from(call.arguments) : {};

    switch (call.method) {
      case 'updateProperties':
        if (!mounted) return;
        setState(() {
          if (argsMap.containsKey('opacity')) {
            _currentOpacity = argsMap['opacity'];
          }
          if (argsMap.containsKey('content')) {
            _textEditingController.text = argsMap['content'];
          }
        });
        break;
      case 'pleaseCloseYourself':
        developer.log(
            'Received close request from main window for ${widget.itemId}. Closing.',
            name: 'PinnedTextWindow');
        _windowController.close();
        break;
      default:
        developer.log('Unknown host method: ${call.method}',
            name: 'PinnedTextWindow');
    }
    return Future.value();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    if (_isInitialized) {
      DesktopMultiWindow.setMethodHandler(null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Material(
          color: Colors.transparent,
          child: Center(child: CircularProgressIndicator()));
    }

    final backgroundColor =
        Theme.of(context).cardColor.withOpacity(_currentOpacity);
    final textColor = Theme.of(context)
        .colorScheme
        .onSurface
        .withOpacity(_currentOpacity > 0.5 ? 1.0 : _currentOpacity * 2);

    return Material(
      color: Colors.transparent,
      child: Card(
        elevation: 4.0,
        color: backgroundColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToolbar(context, textColor),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: _buildContentArea(context, textColor),
              ),
            ),
            _buildOpacitySlider(context),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, Color controlColor) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: const Center(
                      child: Icon(Icons.drag_handle,
                          size: 18, color: Colors.grey)))),
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit,
                size: 16, color: controlColor),
            tooltip: 'Edit Text',
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  DesktopMultiWindow.invokeMethod(
                    0,
                    'updateContent',
                    {
                      'id': widget.itemId,
                      'content': _textEditingController.text
                    },
                  );
                }
                _isEditing = !_isEditing;
              });
            },
          ),
          Tooltip(
            message: _showMarkdown ? 'Show Plain Text' : 'Render Markdown',
            child: Switch(
              value: _showMarkdown,
              onChanged: (value) {
                setState(() {
                  _showMarkdown = value;
                });
              },
              activeColor: Theme.of(context).colorScheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: controlColor),
            tooltip: 'Close Pinned Item',
            onPressed: () {
              developer.log(
                  'Close button pressed for ${widget.itemId}. Closing window.',
                  name: 'PinnedTextWindow');
              DesktopMultiWindow.invokeMethod(
                0,
                'windowClosed',
                widget.itemId,
              ).catchError((e) {
                developer.log(
                    'Error invoking windowClosed method for ${widget.itemId}',
                    name: 'PinnedTextWindow',
                    error: e);
              });
              _windowController.close();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentArea(BuildContext context, Color textColor) {
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor) ??
            TextStyle(color: textColor);
    final currentText = _textEditingController.text;

    if (_isEditing) {
      return TextField(
        controller: _textEditingController,
        autofocus: true,
        maxLines: null,
        expands: true,
        style: textStyle,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      );
    } else {
      if (_showMarkdown) {
        return Scrollbar(
          child: Markdown(
            data: currentText,
            selectable: true,
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: textStyle,
            ),
            padding: EdgeInsets.zero,
          ),
        );
      } else {
        return Scrollbar(
          child: SingleChildScrollView(
            child: SelectableText(
              currentText,
              style: textStyle,
            ),
          ),
        );
      }
    }
  }

  Widget _buildOpacitySlider(BuildContext context) {
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Slider(
        value: _currentOpacity,
        min: 0.1,
        max: 1.0,
        divisions: 9,
        label: 'Opacity: ${(_currentOpacity * 100).toStringAsFixed(0)}%',
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        onChanged: (newOpacity) {
          setState(() {
            _currentOpacity = newOpacity;
          });
          DesktopMultiWindow.invokeMethod(
            0,
            'updateOpacity',
            {'id': widget.itemId, 'opacity': newOpacity},
          );
        },
      ),
    );
  }
}
