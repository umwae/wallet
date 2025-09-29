// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/feature/crypto/domain/entities/coin_entity.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_coin_details_usecase.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_ton_wallet_balance_usecase.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/open_ton_wallet_usecase.dart';
import 'package:stonwallet/src/feature/home/bloc/wallet_bloc.dart';
import 'package:stonwallet/src/feature/home/bloc/wallet_loaded_extension.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/feature/navdec/navdec.dart';
import 'package:stonwallet/src/feature/navdec/navigation_cubit.dart';
import 'package:stonwallet/src/feature/receive/view/receive_view.dart';

/// {@template home_screen}
/// The main screen of the application.
/// {@endtemplate}
class HomeView extends BaseStatefulPage {
  /// {@macro home_screen}
  const HomeView({super.key});

  @override
  BaseStatefulPageState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends BaseStatefulPageState<HomeView> with WidgetsBindingObserver {
  late final _homeLogger = DependenciesScope.of(context).logger.withPrefix('[HOME]');
  late final WalletBloc _walletBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _homeLogger.info('HomeView initialized');

    final deps = DependenciesScope.of(context);
    _walletBloc = WalletBloc(
      getCoinDetailsUseCase: GetCoinDetailsUseCase(deps.coinGeckoRepository),
      getTonWalletBalanceUseCase:
          GetTonWalletBalanceUseCase(deps.tonWalletRepository, logger: _homeLogger),
      openTonWalletUseCase:
          OpenTonWalletUseCase(deps.tonWalletRepository, secureStorage: deps.secureStorage),
    );
    onRefresh(context);
  }

  @override //Загрузка монет и баланса
  Future<void> onRefresh(BuildContext context) async {
    _walletBloc.add(WalletLoadDataEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _walletBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _homeLogger.info('[DBG] App paused - system minimized app');
      return;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final rubFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '₽',
      decimalDigits: 2,
    );
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: colorScheme.surface,
              pinned: true,
              floating: false,
              snap: false,
              toolbarHeight: 0,
              collapsedHeight: 420,
              expandedHeight: 420,
              stretch: false,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    expandedTitleScale: 1.0,
                    background: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Container(
                        height: 420,
                        color: colorScheme.surface,
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton.filled(
                                        onPressed: () => context
                                            .read<NavigationCubit>()
                                            .push(Routes.counter.toPage()),
                                        icon: const Icon(Icons.lock),
                                        style: IconButton.styleFrom(
                                          backgroundColor: colorScheme.primary,
                                          foregroundColor: colorScheme.onPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'testaccount',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.copy),
                                        color: colorScheme.onSurfaceVariant,
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.qr_code),
                                        color: colorScheme.onSurfaceVariant,
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.notifications_none),
                                        color: colorScheme.onSurfaceVariant,
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  BlocBuilder<WalletBloc, WalletState>(
                                    bloc: _walletBloc,
                                    builder: (context, state) {
                                      final balanceText = switch (state) {
                                        WalletLoaded() => state
                                            .toWalletEntity(
                                              formatter: rubFormatter,
                                              context: context,
                                            )
                                            .convertedTotalBalance,
                                        _ => '',
                                      };
                                      return Text(
                                        balanceText,
                                        style: theme.textTheme.displaySmall?.copyWith(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // _WalletAction(icon: Icons.add, label: 'Buy'),
                                      // _WalletAction(icon: Icons.swap_horiz, label: 'Swap'),
                                      // _WalletAction(icon: Icons.hub, label: 'Bridge'),
                                      Expanded(
                                        child: _WalletAction(
                                          icon: Icons.arrow_upward,
                                          label: 'Отправить',
                                          action: () => context
                                              .read<NavigationCubit>()
                                              .push(Routes.scanner.toPage()),
                                        ),
                                      ),
                                      Expanded(
                                        child: BlocBuilder<WalletBloc, WalletState>(
                                          bloc: _walletBloc,
                                          builder: (context, state) {
                                            return switch (state) {
                                              WalletLoaded() => _WalletAction(
                                                  icon: Icons.arrow_downward,
                                                  label: 'Получить',
                                                  action: () => openBottomSheet(
                                                    context,
                                                    itemBuilder: (_) =>
                                                        ReceiveView(address: state.address),
                                                  ),
                                                ),
                                              _ => const CircularProgressIndicator(),
                                            };
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                color: colorScheme.secondaryContainer,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(Icons.emoji_events, color: colorScheme.primary),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            text: 'Earn \$30 in crypto\n',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              color: colorScheme.onSecondaryContainer,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Learn and earn rewards with quests.',
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  color: colorScheme.onSecondaryContainer,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Text(
                                    'Crypto',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'NFTs',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'DeFi',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: colorScheme.surface,
                height: 16,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                BlocBuilder<WalletBloc, WalletState>(
                  bloc: _walletBloc,
                  builder: (context, state) {
                    if (state is WalletLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WalletFailure) {
                      return Center(
                        child: Text(
                          'Ошибка: ${state.error}',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      );
                    } else if (state is WalletLoaded) {
                      final coinEntitys =
                          state.toWalletEntity(formatter: rubFormatter, context: context).assets;
                      return Column(
                        children: [
                          ...coinEntitys.map((c) => _AssetItem(coinEntity: c)).toList(),
                          // _AssetItem(coinEntity: coinEntitys.last),
                          // _AssetItem(coinEntity: coinEntitys.last)
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? action;

  const _WalletAction({
    required this.icon,
    required this.label,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          FilledButton(
            onPressed: action,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                // side: BorderSide(width: 5, color: colorScheme.onSurfaceVariant),
              ),
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              // padding: const EdgeInsets.all(16),
              iconColor: colorScheme.onPrimaryContainer,
              surfaceTintColor: colorScheme.tertiaryContainer,
              elevation: 3,
            ),
            child: Icon(icon),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _AssetItem extends StatelessWidget {
  final CoinEntity coinEntity;

  const _AssetItem({required this.coinEntity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      color: colorScheme.surfaceVariant,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
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
        title: Text(
          coinEntity.name,
          style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
        ),
        subtitle: Row(
          children: [
            Text(
              coinEntity.priceFormatted,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(width: 8),
            Text(
              coinEntity.priceChangePercentage24h ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(color: coinEntity.earningsColor),
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              coinEntity.coinBalanceConverted,
              style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
            ),
            Text(
              coinEntity.coinBalance,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        onTap: () => context.read<NavigationCubit>().push(
              Routes.currentDetail.toPage(arguments: {'coinEntity': coinEntity}),
            ),
      ),
    );
  }
}
