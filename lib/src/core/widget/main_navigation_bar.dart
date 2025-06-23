import 'package:flutter/material.dart';

/// {@template main_navigation_bar}
/// Основная навигационная панель приложения
/// {@endtemplate}
class MainNavigationBar extends StatelessWidget {
  /// {@macro main_navigation_bar}
  const MainNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}