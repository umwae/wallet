import 'package:flutter/material.dart';

class AnimatedMaterialPage<T> extends MaterialPage<T> {
  const AnimatedMaterialPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.maintainState,
    super.fullscreenDialog,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
