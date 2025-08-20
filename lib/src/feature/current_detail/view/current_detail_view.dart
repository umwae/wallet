// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/chart_graph_scope.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/current_detail_cubit.dart';

class CurrentDetailView extends StatelessWidget {
  const CurrentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1C2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF152A3A),
        title: Text('Toncoin'),
        centerTitle: true,
        leading: const BackButton(),
        // actions: const [Icon(Icons.close), SizedBox(width: 16)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '232,84 ₽',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.currency_bitcoin, color: Colors.white),
              ),
            ],
          ),
          BlocBuilder<CurrentDetailCubit, int>(
            builder: (context, periodIndex) {
              return ChartGraphScope(
                key: ValueKey(periodIndex),
                id: 'the-open-network',
                vsCurrency: 'rub',
                from: _getFromByPeriod(periodIndex),
                to: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                // interval: 'daily',
              );
            },
          ),
          const SizedBox(height: 16),
          // Баланс TON
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2E40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ваш баланс в TON', style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 8),
                      Text(
                        '0,00 ₽',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('0,00000001 TON', style: TextStyle(color: Colors.white38)),
                    ],
                  ),
                ),
                Icon(Icons.qr_code, color: Colors.white54),
                SizedBox(width: 12),
                Text('Получить TON', style: TextStyle(color: Colors.blueAccent)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text('О криптовалюте', style: TextStyle(color: Colors.white70)),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                  child: const Text('Купить', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text('Продать'),
                ),
              ),
            ],
          ),
        ],
      ),
      // bottomNavigationBar: const MainNavigationBar(),
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
