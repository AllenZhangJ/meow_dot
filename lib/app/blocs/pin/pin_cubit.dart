import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/services.dart'; // Import for MethodCall
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meow_dot/domain/models/pinned_item.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

part 'pin_state.dart';

@lazySingleton
class PinCubit extends Cubit<PinState> {
  final Uuid _uuid = const Uuid();
  final Map<String, int> _windowIdMap = {};

  PinCubit() : super(const PinState()) {
    // Register handler with the correct signature
    DesktopMultiWindow.setMethodHandler(_handleMethodCallback);
  }

  // Corrected Handler for messages/events coming FROM sub-windows
  Future<dynamic> _handleMethodCallback(
      MethodCall call, int fromWindowId) async {
    developer.log(
        'Main window received method: ${call.method} from $fromWindowId, args: ${call.arguments}',
        name: 'PinCubit');
    // Arguments are now in call.arguments
    final Map<String, dynamic> argsMap =
        call.arguments is Map ? Map<String, dynamic>.from(call.arguments) : {};
    // Get itemId which might be directly in arguments for windowClosed or inside the map
    final String? itemId = argsMap['itemId'] as String? ??
        (call.arguments is String ? call.arguments : null);

    switch (call.method) {
      // Use call.method
      case 'windowCreated':
        final int windowId = argsMap['windowId'] as int;
        final String createdItemId = argsMap['itemId']
            as String; // Assuming itemId is always in argsMap for this call
        _windowIdMap[createdItemId] = windowId;
        developer.log(
            'Registered window mapping: Item $createdItemId -> Window $windowId',
            name: 'PinCubit');
        break;
      case 'windowClosed':
        final String closedItemId =
            call.arguments as String; // Argument is directly the itemId string
        if (state.pinnedItems.any((item) => item.id == closedItemId)) {
          developer.log(
              'Removing item $closedItemId from state due to external close.',
              name: 'PinCubit');
          _windowIdMap.remove(closedItemId);
          removePinnedItem(closedItemId, closeWindow: false);
        } else {
          developer.log(
              'Received windowClosed for $closedItemId, but item not found in state (already removed?).',
              name: 'PinCubit');
          _windowIdMap.remove(closedItemId);
        }
        break;
      case 'updatePosition':
        if (itemId != null &&
            argsMap.containsKey('dx') &&
            argsMap.containsKey('dy')) {
          final double dx = argsMap['dx'] as double;
          final double dy = argsMap['dy'] as double;
          updatePinnedItem(itemId,
              position: Offset(dx, dy), triggerWindowUpdate: false);
        }
        break;
      case 'updateSize':
        if (itemId != null &&
            argsMap.containsKey('width') &&
            argsMap.containsKey('height')) {
          final double width = argsMap['width'] as double;
          final double height = argsMap['height'] as double;
          updatePinnedItem(itemId,
              size: Size(width, height), triggerWindowUpdate: false);
        }
        break;
      case 'updateOpacity':
        if (itemId != null && argsMap.containsKey('opacity')) {
          final double opacity = argsMap['opacity'] as double;
          updatePinnedItem(itemId,
              opacity: opacity, triggerWindowUpdate: false);
        }
        break;
      case 'updateContent':
        if (itemId != null && argsMap.containsKey('content')) {
          final String content = argsMap['content'] as String;
          updatePinnedItem(itemId,
              content: content, triggerWindowUpdate: false);
        }
        break;
      default:
        developer.log('Unknown method call from sub window: ${call.method}',
            name: 'PinCubit');
    }
    return Future.value();
  }

  Future<void> addPinnedItem({
    required PinnedContentType contentType,
    required dynamic content,
    Offset? initialPosition,
    Size? initialSize,
    double initialOpacity = 1.0,
  }) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final newItem = PinnedItem(
        id: _uuid.v4(),
        contentType: contentType,
        content: content,
        position: initialPosition,
        size: initialSize ?? const Size(300, 200),
        opacity: initialOpacity,
        createdAt: DateTime.now(),
      );

      String windowType;
      switch (contentType) {
        case PinnedContentType.text:
          windowType = 'pinnedText';
          break;
        case PinnedContentType.image:
          windowType = 'pinnedImage';
          break;
      }

      final arguments = jsonEncode({
        'type': windowType,
        'itemId': newItem.id,
        'initialContent': newItem.content,
        'initialOpacity': newItem.opacity,
        'initialWidth': newItem.size?.width,
        'initialHeight': newItem.size?.height,
        'initialPosX': newItem.position?.dx,
        'initialPosY': newItem.position?.dy,
      });

      developer.log(
          'Creating window for item ${newItem.id} with args: $arguments',
          name: 'PinCubit');

      await DesktopMultiWindow.createWindow(arguments);
      developer.log(
          'Window creation command sent for item ${newItem.id}. Waiting for registration via windowCreated event.',
          name: 'PinCubit');

      final updatedList = List<PinnedItem>.from(state.pinnedItems)
        ..add(newItem);
      emit(state.copyWith(
        pinnedItems: updatedList,
        status: BlocStatus.success,
        clearErrorMessage: true,
      ));
    } catch (e, s) {
      developer.log('Failed to add pinned item or create window',
          name: 'PinCubit', error: e, stackTrace: s);
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: 'Failed to add pinned item: $e',
      ));
    }
  }

  Future<void> removePinnedItem(String id, {bool closeWindow = true}) async {
    final itemIndex = state.pinnedItems.indexWhere((item) => item.id == id);
    if (itemIndex == -1 && closeWindow) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: 'Pinned item with ID $id not found for removal.',
      ));
      return;
    }

    final int? windowIdToClose = _windowIdMap[id];

    if (itemIndex != -1) {
      final updatedList =
          state.pinnedItems.where((item) => item.id != id).toList();
      emit(state.copyWith(
        pinnedItems: updatedList,
        status: BlocStatus.loading,
        clearErrorMessage: true,
      ));
      _windowIdMap.remove(id);
    } else if (closeWindow) {
      emit(state.copyWith(status: BlocStatus.loading));
      _windowIdMap.remove(id);
    } else {
      return;
    }

    try {
      if (closeWindow && windowIdToClose != null) {
        developer.log(
            'Requesting window ID $windowIdToClose (Item $id) to close itself.',
            name: 'PinCubit');
        await DesktopMultiWindow.invokeMethod(
          windowIdToClose,
          'pleaseCloseYourself',
          null,
        );
        developer.log('Close request sent to window ID: $windowIdToClose.',
            name: 'PinCubit');
      } else if (closeWindow) {
        developer.log(
            'Could not find window ID mapping for item $id to send close request.',
            name: 'PinCubit');
      }

      emit(state.copyWith(
        status: BlocStatus.success,
      ));
    } catch (e, s) {
      developer.log('Failed to send close request for item $id',
          name: 'PinCubit', error: e, stackTrace: s);
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: 'Failed to send close request for item $id: $e',
      ));
    }
  }

  void updatePinnedItem(String id,
      {Offset? position,
      Size? size,
      double? opacity,
      dynamic content,
      bool triggerWindowUpdate = true}) {
    final itemIndex = state.pinnedItems.indexWhere((item) => item.id == id);
    if (itemIndex == -1) {
      if (triggerWindowUpdate) {
        emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: 'Pinned item with ID $id not found for update.',
        ));
      }
      developer.log(
          'Attempted to update item $id which is not in state (triggerWindowUpdate: $triggerWindowUpdate).',
          name: 'PinCubit');
      return;
    }

    if (triggerWindowUpdate) {
      emit(state.copyWith(status: BlocStatus.loading));
    }

    try {
      final currentItem = state.pinnedItems[itemIndex];
      final updatedItem = currentItem.copyWith(
        position: position,
        size: size,
        opacity: opacity,
        content: content,
      );

      final updatedList = List<PinnedItem>.from(state.pinnedItems);
      updatedList[itemIndex] = updatedItem;

      emit(state.copyWith(
        pinnedItems: updatedList,
        status: BlocStatus.success,
        clearErrorMessage: true,
      ));

      if (triggerWindowUpdate) {
        final int? windowId = _windowIdMap[id];
        if (windowId != null) {
          developer.log(
              'Sending updateProperties to window $windowId for item $id',
              name: 'PinCubit');
          DesktopMultiWindow.invokeMethod(
            windowId,
            'updateProperties',
            {
              if (opacity != null) 'opacity': opacity,
              if (position != null) 'posX': position.dx,
              if (position != null) 'posY': position.dy,
              if (size != null) 'width': size.width,
              if (size != null) 'height': size.height,
              if (content != null) 'content': content,
            },
          ).catchError((e) {
            developer.log(
                'Error invoking updateProperties for window $windowId (Item $id)',
                name: 'PinCubit',
                error: e);
          });
        } else {
          developer.log(
              'Could not find window ID mapping for item $id to send update.',
              name: 'PinCubit');
        }
      }
    } catch (e, s) {
      developer.log('Failed to update pinned item $id',
          name: 'PinCubit', error: e, stackTrace: s);
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: 'Failed to update pinned item $id: $e',
      ));
    }
  }

  @override
  Future<void> close() {
    DesktopMultiWindow.setMethodHandler(null);
    _windowIdMap.clear();
    return super.close();
  }
}
