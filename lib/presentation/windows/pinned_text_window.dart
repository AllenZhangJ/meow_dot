/**
 * 日期: 2025/4/29
 * 文件: pinned_text_window
 * 包名: presentation.windows
 * 用户: allenaaron
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // For Markdown rendering
import 'package:meow_dot/app/blocs/pin/pin_cubit.dart'; // Import PinCubit
import 'package:meow_dot/domain/models/pinned_item.dart'; // Import PinnedItem model

/// A window widget to display pinned text content.
///
/// It receives the [itemId] and uses BlocProvider to access the [PinCubit]
/// to get the actual item details and handle updates/removal.
class PinnedTextWindow extends StatefulWidget {
  final String itemId; // ID of the PinnedItem to display

  const PinnedTextWindow({
    super.key,
    required this.itemId,
  });

  @override
  State<PinnedTextWindow> createState() => _PinnedTextWindowState();
}

class _PinnedTextWindowState extends State<PinnedTextWindow> {
  bool _isEditing = false;
  bool _showMarkdown = true; // Default to showing Markdown rendering
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller. We get the initial text via BlocBuilder later.
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use BlocSelector to listen only to changes of the specific item
    // and rebuild only when necessary.
    return BlocSelector<PinCubit, PinState, PinnedItem?>(
      selector: (state) {
        try {
          // Find the item by ID. Returns null if not found.
          return state.pinnedItems
              .firstWhere((item) => item.id == widget.itemId);
        } catch (e) {
          // Item might have been removed
          return null;
        }
      },
      builder: (context, pinnedItem) {
        // If the item is null (e.g., removed), display an empty container or handle appropriately.
        if (pinnedItem == null) {
          // Optionally, trigger window close here if the item disappears
          // This logic might be better handled where the window is created/managed.
          print('Pinned item ${widget.itemId} not found in state.');
          return const SizedBox.shrink(); // Or a placeholder/error widget
        }

        // Update text controller only if not editing or if content changed externally
        if (!_isEditing &&
            _textEditingController.text != pinnedItem.content as String) {
          _textEditingController.text = pinnedItem.content as String;
        }

        // Determine the background color based on opacity
        final backgroundColor =
            Theme.of(context).cardColor.withOpacity(pinnedItem.opacity);
        final textColor = Theme.of(context).colorScheme.onSurface.withOpacity(
            pinnedItem.opacity > 0.5
                ? 1.0
                : pinnedItem.opacity * 2); // Adjust text visibility

        return Material(
          // Use Material for proper theme application
          color: Colors.transparent, // Make Material background transparent
          child: Card(
            elevation: 4.0,
            // Apply opacity to the Card's color, allowing content to inherit adjusted opacity
            color: backgroundColor,
            margin: EdgeInsets.zero,
            // Remove default Card margin
            shape: RoundedRectangleBorder(
              // Optional: Define shape if needed
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Fit content size
              children: [
                // --- Toolbar ---
                _buildToolbar(context, pinnedItem, textColor),

                // --- Content Area ---
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: _buildContentArea(context, pinnedItem, textColor),
                  ),
                ),

                // --- Opacity Slider --- (Optional: place at bottom)
                _buildOpacitySlider(context, pinnedItem),
              ],
            ),
          ),
        );
      },
    );
  }

  // Builds the top toolbar with controls
  Widget _buildToolbar(
      BuildContext context, PinnedItem pinnedItem, Color controlColor) {
    // Simple toolbar using Row, customize as needed
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      // Add a subtle background or border if needed
      // decoration: BoxDecoration(
      //   border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      // ),
      child: Row(
        children: [
          // Placeholder for potential drag handle (can be the whole bar)
          const Expanded(
            child: SizedBox(height: 30), // Height for dragging
          ),

          // Edit Button
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit,
                size: 16, color: controlColor),
            tooltip: _isEditing ? 'Save' : 'Edit Text',
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  // Save changes via Cubit
                  context.read<PinCubit>().updatePinnedItem(
                        widget.itemId,
                        content: _textEditingController.text,
                      );
                }
                _isEditing = !_isEditing;
              });
            },
          ),

          // Markdown Toggle
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
              // Make switch smaller if needed
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),

          // Close Button
          IconButton(
            icon: Icon(Icons.close, size: 18, color: controlColor),
            tooltip: 'Close Pinned Item',
            onPressed: () {
              // Call Cubit to remove the item state
              context.read<PinCubit>().removePinnedItem(widget.itemId);
              // TODO: Add call to WindowManager to actually close the window
              // Example: WindowManager.instance.close(); (Requires window context)
            },
          ),
        ],
      ),
    );
  }

  // Builds the main content area (Text or Markdown)
  Widget _buildContentArea(
      BuildContext context, PinnedItem pinnedItem, Color textColor) {
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor) ??
            TextStyle(color: textColor);

    if (_isEditing) {
      return TextField(
        controller: _textEditingController,
        autofocus: true,
        maxLines: null,
        // Allows multiline editing
        expands: true,
        // Fill available space
        style: textStyle,
        decoration: const InputDecoration(
          border: InputBorder.none, // No border inside the card
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      );
    } else {
      if (_showMarkdown) {
        // Render Markdown
        return Markdown(
          data: pinnedItem.content as String,
          selectable: true, // Allow text selection
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: textStyle, // Apply text color to paragraphs
            // Customize other markdown elements if needed
            // h1: textStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // Ensure background is transparent to show card color
          padding: EdgeInsets.zero,
        );
      } else {
        // Render Plain Text
        return SelectableText(
          pinnedItem.content as String,
          style: textStyle,
        );
      }
    }
  }

  // Builds the opacity slider
  Widget _buildOpacitySlider(BuildContext context, PinnedItem pinnedItem) {
    return Container(
      height: 25, // Slider height
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Slider(
        value: pinnedItem.opacity,
        min: 0.1,
        // Minimum opacity (avoid fully transparent)
        max: 1.0,
        divisions: 9,
        // 10 steps (0.1, 0.2, ..., 1.0)
        // label: 'Opacity: ${(pinnedItem.opacity * 100).toStringAsFixed(0)}%', // Optional label
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        onChanged: (newOpacity) {
          // Update via Cubit - this triggers rebuild via BlocSelector
          context.read<PinCubit>().updatePinnedItem(
                widget.itemId,
                opacity: newOpacity,
              );
          // TODO: Add call to WindowManager to set opacity
          // Example: WindowManager.instance.setOpacity(newOpacity);
        },
      ),
    );
  }
}
