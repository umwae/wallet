import 'package:flutter/material.dart';
import 'package:stonwallet/src/core/utils/extensions/app_theme_extension.dart';
import 'package:stonwallet/src/core/widget/app_snackbar.dart';

class AppLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final bool _fullscreen;
  final String? snackbarText;

  const AppLoader({super.key, this.width, this.height, this.snackbarText}) : _fullscreen = false;

// С цветным фоном
  const AppLoader.fullscreen({super.key, this.width, this.height, this.snackbarText})
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
      color: _fullscreen ? Theme.of(context).extension<ExtraColors>()!.bgGradientEnd : null,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
