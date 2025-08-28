import 'package:flutter/material.dart';

/// {@template main_navigation_bar}
/// Основная навигационная панель приложения
/// {@endtemplate}
class MainNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int)? onTap;

  /// {@macro main_navigation_bar}
  const MainNavigationBar({
    this.currentIndex = 0,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        // highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Assets'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
