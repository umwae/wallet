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
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          // highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Кошелек'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Транзакции'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
          ],
        ),
      ),
    );
  }
}
