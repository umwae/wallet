// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/widgets.dart';

extension WidgetExtension on Widget {
  Widget showIf(bool predicate) => predicate ? this : const SizedBox.shrink();
}
