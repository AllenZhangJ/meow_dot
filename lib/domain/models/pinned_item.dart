/**
 * 日期: 2025/4/29
 * 文件: pinned_item
 * 包名: domain.models
 * 用户: allenaaron
 */

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // For Offset, Size, Color etc.

/// Represents the type of content being pinned.
enum PinnedContentType {
  text,
  image,
  // Potentially add markdown later as a distinct type or handle within text
}

/// Represents a single item pinned to the top of the screen.
/// This is a basic structure, more properties will be added as needed.
class PinnedItem extends Equatable {
  /// Unique identifier for the pinned item.
  final String id;

  /// The type of content being pinned.
  final PinnedContentType contentType;

  /// The actual content (e.g., text string, image path/data).
  /// Using dynamic for now, consider specific types or interfaces later.
  final dynamic content;

  /// The position of the top-left corner of the pinned window.
  /// Nullable initially, set when the window is shown.
  final Offset? position;

  /// The size of the pinned window.
  /// Nullable initially, set when the window is shown or resized.
  final Size? size;

  /// The transparency level (0.0 fully transparent, 1.0 fully opaque).
  final double opacity;

  /// Timestamp when the item was created.
  final DateTime createdAt;

  const PinnedItem({
    required this.id,
    required this.contentType,
    required this.content,
    this.position,
    this.size,
    this.opacity = 1.0, // Default to fully opaque
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, contentType, content, position, size, opacity, createdAt];

  /// Creates a copy of this PinnedItem but with the given fields replaced.
  PinnedItem copyWith({
    String? id,
    PinnedContentType? contentType,
    dynamic content,
    Offset? position,
    Size? size,
    double? opacity,
    DateTime? createdAt,
  }) {
    return PinnedItem(
      id: id ?? this.id,
      contentType: contentType ?? this.contentType,
      content: content ?? this.content,
      position: position ?? this.position,
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
