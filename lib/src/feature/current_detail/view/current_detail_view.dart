// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/feature/crypto/domain/entities/coin_entity.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/chart_graph_cubit.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/chart_graph_scope.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/current_detail_cubit.dart';
import 'package:translator/translator.dart';

class CurrentDetailView extends BasePage {
  final CoinEntity coinEntity;
  final translator = GoogleTranslator();
  CurrentDetailView({required this.coinEntity, super.key});

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
        title: Text(coinEntity.name,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    coinEntity.priceFormatted,
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primaryContainer,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: coinEntity.iconURL ?? 'https://example.com/icon.png',
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<CurrentDetailCubit, int>(
            builder: (context, periodIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ChartGraphScope(
                  key: ValueKey(periodIndex),
                  id: coinEntity.id,
                  vsCurrency: 'rub',
                  from: _getFromByPeriod(periodIndex),
                  to: DateFormat("yyyy-MM-dd'T'HH:mm").format(DateTime.now()),
                  interval: null,
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
                        Text(
                          'Ваш баланс в ${coinEntity.symbol}',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSecondaryContainer),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          coinEntity.coinBalanceConverted,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('${coinEntity.coinBalance}',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSecondaryContainer.withOpacity(0.6))),
                      ],
                    ),
                  ),
                  Icon(Icons.qr_code, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Text('Получить ${coinEntity.symbol}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('О криптовалюте',
                style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder(
              future: translator.translate(coinEntity.description, to: 'ru'),
              builder: (context, snapshot) => Text(
                snapshot.data?.text ?? coinEntity.description,
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ),
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
      return DateFormat("yyyy-MM-dd'T'HH:mm").format(now.subtract(Duration(days: 1)));
    case 1:
      return DateFormat("yyyy-MM-dd'T'HH:mm").format(now.subtract(Duration(days: 7)));
    case 2:
      return DateFormat("yyyy-MM-dd'T'HH:mm").format(DateTime(now.year, now.month - 1, now.day));
    case 3:
      return DateFormat("yyyy-MM-dd'T'HH:mm").format(DateTime(now.year - 1, now.month, now.day));
    default:
      return DateFormat("yyyy-MM-dd'T'HH:mm").format(now.subtract(Duration(days: 1)));
  }
}
