import 'package:flutter/material.dart';
import 'package:stonwallet/src/core/utils/extensions/app_theme_extension.dart';
import 'package:stonwallet/src/core/widget/app_snackbar.dart';

class AppErrorWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final bool _fullscreen;
  final String? snackbarText;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, this.width, this.height, this.snackbarText, this.onRetry})
      : _fullscreen = false;

// С цветным фоном
  const AppErrorWidget.fullscreen(
      {super.key, this.width, this.height, this.snackbarText, this.onRetry})
      : _fullscreen = true;

  @override
  Widget build(BuildContext context) {
    if (snackbarText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            AppSnackBar(snackbarText!, context),
          );
      });
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border:
            _fullscreen ? null : Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant),
        borderRadius: BorderRadius.circular(16),
        color: _fullscreen ? Theme.of(context).extension<ExtraColors>()!.bgGradientEnd : null,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            if (_fullscreen) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: const Text('Повторить')),
            ],
          ],
        ),
      ),
    );
  }
}
