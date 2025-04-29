/**
 * 日期: 2025/4/29
 * 文件: pin_state
 * 包名: app.blocs.pin
 * 用户: allenaaron
 */

part of 'pin_cubit.dart'; // Link to the cubit file

/// Represents the state for the Pin feature.
class PinState extends Equatable {
  /// List of currently active pinned items.
  final List<PinnedItem> pinnedItems;

  /// Status indicator for loading or processing.
  final BlocStatus status; // You might need to define BlocStatus enum elsewhere

  /// Optional error message.
  final String? errorMessage;

  const PinState({
    this.pinnedItems = const [], // Default to an empty list
    this.status = BlocStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [pinnedItems, status, errorMessage];

  /// Creates a copy of the state with updated values.
  PinState copyWith({
    List<PinnedItem>? pinnedItems,
    BlocStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false, // Helper to explicitly clear error
  }) {
    return PinState(
      pinnedItems: pinnedItems ?? this.pinnedItems,
      status: status ?? this.status,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// Enum to represent the status of Bloc operations.
/// Define this in a shared location, e.g., lib/core/bloc/bloc_status.dart
/// or just define it here for now if not shared yet.
enum BlocStatus { initial, loading, success, failure }
