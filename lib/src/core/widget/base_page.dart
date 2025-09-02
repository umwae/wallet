import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

abstract class BasePage extends StatelessWidget {
  const BasePage({super.key});

  Future<void> onRefresh(BuildContext context) async {
    // Базовая реализация по умолчанию
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      clipBehavior: Clip.antiAlias,
      triggerMode: IndicatorTriggerMode.anywhere,
      onRefresh: () => onRefresh(context),
      child: buildContent(context),
    );
  }

  Widget buildContent(BuildContext context);
}

abstract class BaseStatefulPage extends StatefulWidget {
  const BaseStatefulPage({super.key});
}

abstract class BaseStatefulPageState<T extends BaseStatefulPage> extends State<T> {
  Future<void> onRefresh(BuildContext context) async {
    // Базовая реализация по умолчанию
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      clipBehavior: Clip.antiAlias,
      triggerMode: IndicatorTriggerMode.anywhere,
      onRefresh: () => onRefresh(context),
      child: buildContent(context),
    );
  }

  Widget buildContent(BuildContext context);
}
