// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/core/widget/main_navigation_bar.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/current_detail_cubit.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/feature/navdec/navdec.dart';
import 'package:stonwallet/src/feature/crypto/presentation/bloc/coingecko_auth_bloc.dart';
import 'package:stonwallet/src/feature/crypto/presentation/bloc/coingecko_coins_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_coin_details_usecase.dart';
import 'package:stonwallet/src/core/utils/extensions/coingecko_details_extension.dart';
import 'package:stonwallet/src/feature/home/view/asset_item_vm.dart';

/// {@template home_screen}
/// HomePage is a simple screen that displays a grid of items.
/// {@endtemplate}
class HomePage extends BaseStatefulPage {
  /// {@macro home_screen}
  const HomePage({super.key});

  @override
  BaseStatefulPageState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseStatefulPageState<HomePage> with WidgetsBindingObserver {
  late final _homeLogger = DependenciesScope.of(context).logger.withPrefix('[HOME]');
  late final CoinGeckoCoinsBloc _coinsBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _homeLogger.info('HomePage initialized');

    // Инициируем аутентификацию CoinGecko
    context.read<CoinGeckoAuthBloc>().add(AuthenticateCoinGeckoEvent());
    // Инициализация и запуск загрузки монет
    final deps = DependenciesScope.of(context);
    _coinsBloc = CoinGeckoCoinsBloc(GetCoinDetailsUseCase(deps.coinGeckoRepository));
    _coinsBloc.add(FetchCoinsDetailsEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _coinsBloc.close();
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
    final formatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '₽',
      decimalDigits: 2,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              pinned: true,
              floating: false,
              snap: false,
              toolbarHeight: 0,
              collapsedHeight: 450,
              expandedHeight: 450,
              stretch: false,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    expandedTitleScale: 1.0,
                    background: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Container(
                        height: 450,
                        color: Colors.black,
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Icon(Icons.lock, color: Colors.white),
                                        ),
                                        onTap: () =>
                                            AppNavigator.push(context, Routes.counter.page()),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'testaccount',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Icon(Icons.copy, color: Colors.white),
                                      SizedBox(width: 12),
                                      Icon(Icons.qr_code, color: Colors.white),
                                      SizedBox(width: 12),
                                      Icon(Icons.notifications_none, color: Colors.white),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    '\$3.13',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: const [
                                      _WalletAction(icon: Icons.add, label: 'Buy'),
                                      _WalletAction(icon: Icons.swap_horiz, label: 'Swap'),
                                      _WalletAction(icon: Icons.hub, label: 'Bridge'),
                                      _WalletAction(icon: Icons.arrow_upward, label: 'Send'),
                                      _WalletAction(icon: Icons.arrow_downward, label: 'Receive'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.emoji_events, color: Colors.white),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              text: 'Earn \$30 in crypto\n',
                                              style: TextStyle(
                                                  color: Colors.white, fontWeight: FontWeight.bold),
                                              children: [
                                                TextSpan(
                                                  text: 'Learn and earn rewards with quests.',
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Icon(Icons.close, color: Colors.white54),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Row(
                                    children: [
                                      Text('Crypto',
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.bold)),
                                      SizedBox(width: 12),
                                      Text('NFTs', style: TextStyle(color: Colors.white54)),
                                      SizedBox(width: 12),
                                      Text('DeFi', style: TextStyle(color: Colors.white54)),
                                    ],
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
                color: Colors.black,
                height: 16,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                BlocBuilder<CoinGeckoCoinsBloc, CoinGeckoCoinsState>(
                  bloc: _coinsBloc,
                  builder: (context, state) {
                    if (state is CoinGeckoCoinsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CoinGeckoCoinsFailure) {
                      return Center(
                          child: Text('Ошибка: \\${state.error}',
                              style: TextStyle(color: Colors.red)));
                    } else if (state is CoinGeckoCoinsLoaded) {
                      final coins = state.coins;
                      return Column(
                        children:
                            coins.map((coin) => _AssetItem(vm: coin.toAssetItemVM())).toList(),
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

  const _WalletAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue[700],
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white))
      ],
    );
  }
}

class _AssetItem extends StatelessWidget {
  final AssetItemVM vm;

  const _AssetItem({required this.vm});

  @override
  Widget build(BuildContext context) {
    final subtitleColor =
        (vm.priceChangePercentage24h ?? '').startsWith('-') ? Colors.red : Colors.green;
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: vm.iconURL ?? 'https://example.com/icon.png',
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
      title: Text(vm.name, style: const TextStyle(color: Colors.white)),
      subtitle: Row(
        children: [
          Text(vm.price, style: const TextStyle(color: Colors.white54)),
          const SizedBox(width: 8),
          Text(vm.priceChangePercentage24h ?? '', style: TextStyle(color: subtitleColor)),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(vm.value, style: const TextStyle(color: Colors.white)),
          Text(vm.amount, style: const TextStyle(color: Colors.white54)),
        ],
      ),
      onTap: () => AppNavigator.push(context, Routes.currentDetail.page()),
    );
  }
}
