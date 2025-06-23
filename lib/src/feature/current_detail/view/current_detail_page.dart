import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/feature/current_detail/current_detail.dart';

/// {@template counter_page}
/// A [StatelessWidget] which is responsible for providing a
/// [CurrentDetailCubit] instance to the [CurrentDetailView].
/// {@endtemplate}
class CurrentDetailPage extends BasePage {
  /// {@macro counter_page}
  const CurrentDetailPage({super.key});
  // static Route<void> route() {
  //   return MaterialPageRoute<void>(builder: (_) => const CurrentDetailPage());
  // }
  @override
  Widget buildContent(BuildContext context) {
    return BlocProvider(
      create: (_) => CurrentDetailCubit(),
      child: const CurrentDetailView(),
    );
  }
}