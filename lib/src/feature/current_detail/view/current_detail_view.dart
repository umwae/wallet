// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/chart_graph_cubit.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/chart_graph_scope.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/current_detail_cubit.dart';

class CurrentDetailView extends BasePage {
  const CurrentDetailView({super.key});

  @override
  Future<void> onRefresh(BuildContext context) async {
    final periodIndex = context.read<CurrentDetailCubit>().state;
    await context.read<ChartGraphCubit>().loadChart(
          id: 'the-open-network',
          vsCurrency: 'rub',
          from: _getFromByPeriod(periodIndex),
          to: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        );
  }

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text('Toncoin',
            style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onSurface)),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: ListView(
        children: [
          Card(
            color: colorScheme.surfaceVariant,
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '232,84 ₽',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary,
                    child: Icon(Icons.currency_bitcoin, color: colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<CurrentDetailCubit, int>(
            builder: (context, periodIndex) {
              debugPrint('++++++++++++ periodIndex: $periodIndex');
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ChartGraphScope(
                  key: ValueKey(periodIndex),
                  id: 'the-open-network',
                  vsCurrency: 'rub',
                  from: _getFromByPeriod(periodIndex),
                  to: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            color: colorScheme.secondaryContainer,
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ваш баланс в TON',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: colorScheme.onSecondaryContainer)),
                        const SizedBox(height: 8),
                        Text(
                          '0,00 ₽',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('0,00000001 TON',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSecondaryContainer.withOpacity(0.6))),
                      ],
                    ),
                  ),
                  Icon(Icons.qr_code, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Text('Получить TON',
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('О криптовалюте',
                style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          ),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  foregroundColor: colorScheme.primary,
                ),
                child: Text('Купить',
                    style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.primary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: Text('Продать',
                    style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getFromByPeriod(int periodIndex) {
  final now = DateTime.now();
  switch (periodIndex) {
    case 0:
      return DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));
    case 1:
      return DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 7)));
    case 2:
      return DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month - 1, now.day));
    case 3:
      return DateFormat('yyyy-MM-dd').format(DateTime(now.year - 1, now.month, now.day));
    default:
      return DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));
  }
}
