/**
 * 日期: 2025/4/29
 * 文件: pin_cubit
 * 包名: app.blocs.pin
 * 用户: allenaaron
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:injectable/injectable.dart'; // Import injectable
import 'package:meow_dot/domain/models/pinned_item.dart';
import 'package:uuid/uuid.dart';

part 'pin_state.dart';

/// Manages the state of pinned items.
@lazySingleton // Register PinCubit as a lazy singleton with GetIt
class PinCubit extends Cubit<PinState> {
  final Uuid _uuid = const Uuid();

  PinCubit() : super(const PinState());

  /// Adds a new item to be pinned.
  void addPinnedItem({
    required PinnedContentType contentType,
    required dynamic content,
    Offset? initialPosition,
    Size? initialSize,
  }) {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final newItem = PinnedItem(
        id: _uuid.v4(),
        contentType: contentType,
        content: content,
        position: initialPosition,
        size: initialSize,
        createdAt: DateTime.now(),
      );

      final updatedList = List<PinnedItem>.from(state.pinnedItems)..add(newItem);

      emit(state.copyWith(
        pinnedItems: updatedList,
        status: BlocStatus.success,
        clearErrorMessage: true,
      ));
      // TODO: Trigger window creation logic here (e.g., call a service)
    } catch (e) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: 'Failed to add pinned item: $e',
      ));
    }
  }

  /// Removes a pinned item based on its ID.
  void removePinnedItem(String id) {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final updatedList = state.pinnedItems.where((item) => item.id != id).toList();

      if (updatedList.length < state.pinnedItems.length) {
        emit(state.copyWith(
          pinnedItems: updatedList,
          status: BlocStatus.success,
          clearErrorMessage: true,
        ));
        // TODO: Trigger window closing logic here using the id.
      } else {
        emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: 'Pinned item with ID $id not found.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: 'Failed to remove pinned item: $e',
      ));
    }
  }

  /// Updates properties of an existing pinned item.
  void updatePinnedItem(String id, {Offset? position, Size? size, double? opacity, dynamic content}) {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final itemIndex = state.pinnedItems.indexWhere((item) => item.id == id);
      if (itemIndex != -1) {
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
        // TODO: Trigger window update logic here
      } else {
        emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: 'Pinned item with ID $id not found for update.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: 'Failed to update pinned item: $e',
      ));
    }
  }
}

// Define BlocStatus enum here if not defined globally
// enum BlocStatus { initial, loading, success, failure }
