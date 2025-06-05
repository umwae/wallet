// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/feature/navdec/navdec.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _homeLogger.info('HomePage initialized');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
                Column(
                  children: const [
                    _AssetItem(
                      name: 'Ethereum',
                      value: '\$2.13',
                      amount: '0.00112 ETH',
                      icon: Icons.currency_bitcoin,
                      subtitle: 'Earn 4.11% APY',
                      subtitleColor: Colors.green,
                    ),
                    _AssetItem(
                      name: 'MATIC',
                      value: '\$1.00',
                      amount: '1.11 MATIC',
                      icon: Icons.mic,
                    ),
                    const _AssetItem(
                      name: 'Ethereum',
                      value: '\$2.13',
                      amount: '0.00112 ETH',
                      icon: Icons.currency_bitcoin,
                      subtitle: 'Earn 4.11% APY',
                      subtitleColor: Colors.green,
                    ),
                    const _AssetItem(
                      name: 'MATIC',
                      value: '\$1.00',
                      amount: '1.11 MATIC',
                      icon: Icons.mic,
                    ),
                    const _AssetItem(
                      name: 'Ethereum',
                      value: '\$2.13',
                      amount: '0.00112 ETH',
                      icon: Icons.currency_bitcoin,
                      subtitle: 'Earn 4.11% APY',
                      subtitleColor: Colors.green,
                    ),
                    const _AssetItem(
                      name: 'MATIC',
                      value: '\$1.00',
                      amount: '1.11 MATIC',
                      icon: Icons.mic,
                    ),
                    const _AssetItem(
                      name: 'Ethereum',
                      value: '\$2.13',
                      amount: '0.00112 ETH',
                      icon: Icons.currency_bitcoin,
                      subtitle: 'Earn 4.11% APY',
                      subtitleColor: Colors.green,
                    ),
                    const _AssetItem(
                      name: 'MATIC',
                      value: '\$1.00',
                      amount: '1.11 MATIC',
                      icon: Icons.mic,
                    ),
                    const _AssetItem(
                      name: 'Ethereum',
                      value: '\$2.13',
                      amount: '0.00112 ETH',
                      icon: Icons.currency_bitcoin,
                      subtitle: 'Earn 4.11% APY',
                      subtitleColor: Colors.green,
                    ),
                    const _AssetItem(
                      name: 'MATIC',
                      value: '\$1.00',
                      amount: '1.11 MATIC',
                      icon: Icons.mic,
                    ),
                    const _AssetItem(
                      name: 'Ethereum',
                      value: '\$2.13',
                      amount: '0.00112 ETH',
                      icon: Icons.currency_bitcoin,
                      subtitle: 'Earn 4.11% APY',
                      subtitleColor: Colors.green,
                    ),
                    const _AssetItem(
                      name: 'MATIC',
                      value: '\$1.00',
                      amount: '1.11 MATIC',
                      icon: Icons.mic,
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Assets'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.language), label: 'Browser'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
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
  final String name;
  final String value;
  final String amount;
  final IconData icon;
  final String? subtitle;
  final Color? subtitleColor;

  const _AssetItem({
    required this.name,
    required this.value,
    required this.amount,
    required this.icon,
    this.subtitle,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[800],
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: subtitleColor ?? Colors.white54))
          : Text(amount, style: const TextStyle(color: Colors.white54)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: const TextStyle(color: Colors.white)),
          if (subtitle == null) Text(amount, style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}
