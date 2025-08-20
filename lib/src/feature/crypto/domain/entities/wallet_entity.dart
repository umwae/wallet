import 'package:stonwallet/src/feature/crypto/domain/entities/coin_entity.dart';

class WalletEntity {
  final List<CoinEntity> assets;
  final String totalTonBalance;
  final String convertedTotalBalance;

  const WalletEntity({
    required this.assets,
    required this.totalTonBalance,
    required this.convertedTotalBalance,
  });
}

