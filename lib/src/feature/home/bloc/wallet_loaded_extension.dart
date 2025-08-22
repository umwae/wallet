import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stonwallet/src/core/utils/extensions/app_theme_extension.dart';
import 'package:stonwallet/src/core/utils/extensions/double_extension.dart';
import 'package:stonwallet/src/feature/crypto/domain/entities/wallet_entity.dart';
import 'package:stonwallet/src/feature/crypto/domain/mappers/coin_entity_mapper.dart';
import 'package:stonwallet/src/feature/home/bloc/wallet_bloc.dart';

extension WalletLoadedX on WalletLoaded {
  WalletEntity toWalletEntity({required NumberFormat formatter, required BuildContext context}) {
    final extraColors = Theme.of(context).extension<ExtraColors>()!;
    final assets = coins.map((c) => c.toCoinEntity()).toList();
    //Заполняем балансы каждой криптовалюты
    for (final c in assets) {
      final cryptoFormatter =
          NumberFormat.currency(locale: 'ru_RU', decimalDigits: 2, symbol: c.symbol);
      c.coinBalance = (balances[c.id] ?? 0).floorFormat(numberFormat: cryptoFormatter);
      //Заполняем балансы каждой криптовалюты в рублях/долларах
      c.coinBalanceConverted =
          ((balances[c.id] ?? 0) * double.parse(c.price)).floorFormat(numberFormat: formatter);
      //Заполняем цвет в зависимости от изменения цены
      c.earningsColor = (c.priceChangePercentage24h ?? '').startsWith('-')
          ? extraColors.contentColorRed
          : (c.priceChangePercentage24h ?? '').startsWith('+')
              ? extraColors.contentColorGreen
              : Colors.transparent;
    }

    final totalTonBalance = (coins
                .firstWhereOrNull((c) => c.id == 'the-open-network')
                ?.marketData
                .currentPrice['rub'] ??
            1)
        .floorFormat(numberFormat: formatter);
    final convertedTotalBalance = assets
        .map((c) => double.parse(c.price) * (balances[c.id] ?? 0))
        .reduce((value, element) => value + element)
        .floorFormat(numberFormat: formatter);

    return WalletEntity(
      assets: assets.sorted((a, b) => b.coinBalanceConverted.compareTo(a.coinBalanceConverted)),
      totalTonBalance: totalTonBalance,
      convertedTotalBalance: convertedTotalBalance,
    );
  }
}
