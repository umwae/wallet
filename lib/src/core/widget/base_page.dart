import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:stonwallet/src/feature/navdec/navdec.dart';

abstract class BasePage extends StatelessWidget {
  const BasePage({super.key});

  Future<void> onClose(BuildContext context) async {
    AppNavigator.pop(context);
  }

  Future<void> onRefresh() async {
    // Базовая реализация по умолчанию
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        debugPrint('[DBG] onPopInvoked: didPop=$didPop');
        if (didPop) return;
        await onClose(context);
      },
      child: CustomMaterialIndicator(
        clipBehavior: Clip.antiAlias,
        triggerMode: IndicatorTriggerMode.anywhere,
        onRefresh: onRefresh,
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context);
}

abstract class BaseStatefulPage extends StatefulWidget {
  const BaseStatefulPage({super.key});
}

abstract class BaseStatefulPageState<T extends BaseStatefulPage> extends State<T> {
  Future<void> onClose(BuildContext context) async {
    AppNavigator.pop(context);
  }

  Future<void> onRefresh() async {
    // Базовая реализация по умолчанию
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        debugPrint('[DBG] onPopInvoked: didPop=$didPop');
        if (didPop) return;
        await onClose(context);
      },
      child: CustomMaterialIndicator(
        clipBehavior: Clip.antiAlias,
        triggerMode: IndicatorTriggerMode.anywhere,
        onRefresh: onRefresh,
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context);
}
