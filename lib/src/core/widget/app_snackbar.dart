import 'package:flutter/material.dart';

class AppSnackBar extends SnackBar {
  final String _message;

  AppSnackBar(this._message, BuildContext context)
      : super(
          content: Text(
            _message,
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        );
}
