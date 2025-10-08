// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stonwallet/src/core/utils/extensions/app_theme_extension.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/feature/home/bloc/wallet_bloc.dart';
import 'package:stonwallet/src/feature/home/bloc/wallet_loaded_extension.dart';
import 'package:stonwallet/src/feature/home/view/coin_card.dart';
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
  bool showPromo = true;
  int selectedTab = 0;
  final filters = [WalletFilter.all, WalletFilter.tonBased];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override //Загрузка монет и баланса
  Future<void> onRefresh(BuildContext context) async {
    context.read<WalletBloc>().add(WalletLoadDataEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      return;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final extraColors = Theme.of(context).extension<ExtraColors>()!;
    final rubFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '₽',
      decimalDigits: 2,
    );
    return Scaffold(
      // Градиентный фон
      body: Container(
        color: extraColors.bgGradientEnd,
        child: SafeArea(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: extraColors.bgGradientStart,
                // backgroundColor: Colors.transparent,
                pinned: true,
                floating: false,
                snap: false,
                toolbarHeight: 0,
                collapsedHeight: 400,
                expandedHeight: 400,
                stretch: false,
                flexibleSpace: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [extraColors.bgGradientStart, extraColors.bgGradientEnd],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Аватарка и кнопки
                            BlocBuilder<WalletBloc, WalletState>(
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    IconButton.filled(
                                      onPressed: () => {},
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
                                      onPressed: () => Clipboard.setData(
                                        ClipboardData(
                                          text: state is WalletLoaded ? state.address : '',
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.qr_code),
                                      color: colorScheme.onSurfaceVariant,
                                      onPressed: () => openBottomSheet(
                                        context,
                                        itemBuilder: (_) => ReceiveView(
                                          address: state is WalletLoaded ? state.address : '',
                                        ),
                                      ),
                                    ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.notifications_none),
                                    //   color: colorScheme.onSurfaceVariant,
                                    //   onPressed: () {},
                                    // ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            // Баланс, кнопки Отправить и Получить
                            _balanceCard(rubFormatter, theme, colorScheme, context),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (showPromo)
                        PromoCard(
                          onClosed: () => setState(() {
                            showPromo = false;
                          }),
                        ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildFilters(context, filters),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),
              // Список монет
              SliverList(
                delegate: SliverChildListDelegate([
                  BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      if (state is WalletLoaded) {
                        final coinEntitys =
                            state.toWalletEntity(formatter: rubFormatter, context: context).assets;
                        return Column(
                          children: coinEntitys.map((c) => CoinCard(coinEntity: c)).toList(),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Material _balanceCard(
    NumberFormat rubFormatter,
    ThemeData theme,
    ColorScheme colorScheme,
    BuildContext context,
  ) {
    final extraColors = theme.extension<ExtraColors>()!;
    return Material(
      color: Colors.white.withOpacity(0.03),
      // elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<WalletBloc, WalletState>(
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
                return Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: balanceText.replaceAll(RegExp(r'[^\d\.,]'), ''),
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '  ₽',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _WalletAction(
                    icon: Icons.arrow_upward,
                    label: 'Отправить',
                    gradient: LinearGradient(
                      colors: [
                        extraColors.buttonGradientGreenStart,
                        extraColors.buttonGradientGreenEnd.withOpacity(0.9),
                      ],
                    ),
                    action: () => context.read<NavigationCubit>().push(Routes.scanner.toPage()),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      if (state is WalletLoaded) {
                        return _WalletAction(
                          icon: Icons.arrow_downward,
                          label: 'Получить',
                          gradient: LinearGradient(
                            colors: [
                              extraColors.buttonGradientPurpleStart,
                              extraColors.buttonGradientPurpleEnd,
                            ],
                          ),
                          action: () => openBottomSheet(
                            context,
                            itemBuilder: (_) => ReceiveView(address: state.address),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
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
  final Gradient gradient;
  final VoidCallback? action;

  const _WalletAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: action,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class PromoCard extends StatefulWidget {
  final VoidCallback onClosed;
  const PromoCard({required this.onClosed, super.key});
  @override
  State<PromoCard> createState() => _PromoCardState();
}

class _PromoCardState extends State<PromoCard> {
  bool showPromo = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AnimatedScale(
        scale: showPromo ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        onEnd: widget.onClosed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            color: Colors.white.withOpacity(0.03),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Row(
              children: [
                Icon(Icons.emoji_events_outlined, color: Colors.purple),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Earn \$30 in crypto',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Learn and earn rewards with quests.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => showPromo = false),
                  child: Icon(Icons.close, size: 20, color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildFilters(BuildContext context, List<WalletFilter> filters) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  return BlocBuilder<WalletBloc, WalletState>(
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(
          children: [
            for (final filter in filters)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter.name),
                  selected: state.filter == filter,
                  onSelected: (selected) {
                    context
                        .read<WalletBloc>()
                        .add(WalletFilterEvent(selected ? filter.index : null));
                  },
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: state.filter == filter
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                  ),
                  backgroundColor: colorScheme.surfaceVariant,
                  selectedColor: colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}
