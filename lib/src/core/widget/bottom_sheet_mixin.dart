import 'package:flutter/material.dart';

mixin BottomSheetMixin {
  void openBottomSheet(
    BuildContext context, {
    Widget Function(BuildContext context)? itemBuilder,
    bool isScrollControlled = true,
    Color? backgroundColor,
    Widget Function(Widget)? wrapper,
    bool useRootNavigator = true,
    bool enableDrag = true,
    bool isDismissible = true,
    bool withCloseButton = true,
    String? title,
  }) {
    showModalBottomSheet<void>(
      showDragHandle: false,
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      useRootNavigator: useRootNavigator,
      builder: (context) {
        final child = FractionallySizedBox(
          heightFactor: 0.8,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _titleWidget(title, context),
                      Positioned(
                        right: 0,
                        child: _closeButton(context),
                      ),
                    ],
                  ),
                ),
                itemBuilder?.call(context) ?? const SizedBox(),
              ],
            ),
          ),
        );

        if (wrapper != null) {
          return wrapper.call(child);
        }

        return child;
      },
    );
  }

  Widget _titleWidget(String? title, BuildContext context) {
    return Text(
      title ?? '',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  IconButton _closeButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
      iconSize: 28,
    );
  }

  // Center _topCapsule() {
  //   return Center(
  //     child: Container(
  //       margin: const EdgeInsets.only(top: 12),
  //       width: 40,
  //       height: 4,
  //       decoration: BoxDecoration(
  //         color: const Color.fromARGB(255, 59, 77, 86),
  //         borderRadius: BorderRadius.circular(2),
  //       ),
  //     ),
  //   );
  // }
}
