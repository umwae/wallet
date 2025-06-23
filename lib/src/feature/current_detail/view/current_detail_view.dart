// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:stonwallet/src/feature/current_detail/view/chart_graph.dart';

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
              const Expanded(
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
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '+1,47%  +3,37 ₽  Сегодня',
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        ),
                      ],
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
          const SizedBox(height: 20),
          LineChartSample2(),

          // График (заглушка)
          // Container(
          //   height: 180,
          //   decoration: BoxDecoration(
          //     color: const Color(0xFF1C3145),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: const Center(
          //     child: Text('График цены', style: TextStyle(color: Colors.white38)),
          //   ),
          // ),

          // const SizedBox(height: 12),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: const [
          //     _PeriodTab(title: '1Д', index: 0, selected: true),
          //     _PeriodTab(title: '7Д', index: 1),
          //     _PeriodTab(title: '1М', index: 2),
          //     _PeriodTab(title: '1Г', index: 3),
          //     _PeriodTab(title: 'Все', index: 4),
          //   ],
          // ),

          // const SizedBox(height: 24),

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

          // Бонусы
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFF1A2E40),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: const Row(
          //     children: [
          //       Icon(Icons.savings, color: Colors.greenAccent),
          //       SizedBox(width: 12),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               'Бонусы в TON',
          //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          //             ),
          //             SizedBox(height: 4),
          //             Row(
          //               children: [
          //                 Text('4.1% годовых', style: TextStyle(color: Colors.lightBlueAccent)),
          //                 SizedBox(width: 4),
          //                 Text(
          //                   '— Внесите токены на счёт и зарабатывайте',
          //                   style: TextStyle(color: Colors.white70),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

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

// class _PeriodTab extends StatelessWidget {
//   final String title;
//   final int index;
//   final bool selected;

//   const _PeriodTab({required this.title, required this.index, this.selected = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: selected ? Colors.white24 : Colors.transparent,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: FloatingActionButton(
//             key: const Key('counterView_increment_floatingActionButton'),
//             child: Text(title, style: TextStyle(color: selected ? Colors.white : Colors.white54)),
//             onPressed: () => context.read<CurrentDetailCubit>().changePeriod(index),
//           ),
//     );
//   }
// }
