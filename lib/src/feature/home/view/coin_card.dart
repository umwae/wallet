import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/widget/bold_card.dart';
import 'package:stonwallet/src/feature/crypto/domain/entities/coin_entity.dart';
import 'package:stonwallet/src/feature/navdec/navdec.dart';
import 'package:stonwallet/src/feature/navdec/navigation_cubit.dart';

class CoinCard extends StatefulWidget {
  final CoinEntity coinEntity;

  const CoinCard({required this.coinEntity});

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  bool pressed = false;
  CoinEntity get coin => widget.coinEntity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return BoldCard(
      onTap: () {
        context.read<NavigationCubit>().push(
              Routes.currentDetail.toPage(arguments: {'coinEntity': coin}),
            );
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: colorScheme.primaryContainer,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: coin.iconURL ?? 'https://example.com/icon.png',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.question_mark),
            ),
          ),
        ),
        title: Text(
          coin.name,
          style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              decoration: BoxDecoration(
                color: coin.earningsColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                coin.priceChangePercentage24h ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(color: coin.earningsColor),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              coin.priceFormatted,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              coin.coinBalanceConverted,
              style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
            ),
            Text(
              coin.coinBalance,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
