import 'dart:async';

import 'package:stonwallet/src/core/utils/logger.dart';
import 'package:stonwallet/src/feature/initialization/logic/app_runner.dart';

void main() {
  final logger = DefaultLogger(const LoggingOptions(useDebugPrint: true));

  runZonedGuarded(
    () => AppRunner(logger).initializeAndRun(),
    logger.logZoneError,
  );
}
