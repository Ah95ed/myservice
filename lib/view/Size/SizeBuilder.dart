import 'package:flutter/material.dart';

class SizeBuilder extends InheritedWidget {
  final Size baseSize;
  final double height;
  final double width;

  const SizeBuilder({
    super.key,
    required super.child,
    required this.baseSize,
    required this.height,
    required this.width,
  });

  static SizeBuilder of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SizeBuilder>()!;
  }

  @override
  bool updateShouldNotify(covariant SizeBuilder oldWidget) {
    return baseSize != oldWidget.baseSize ||
        height != oldWidget.height ||
        width != oldWidget.width  ||
        child !=oldWidget.child;
  }
}



