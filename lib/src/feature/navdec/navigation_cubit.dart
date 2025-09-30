// ignore_for_file: unnecessary_parenthesis

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/navdec/navdec.dart';

enum TabIndex { home, transactions, settings }

final defaultStacks = {
  TabIndex.home: [Routes.home.toPage()],
  TabIndex.transactions: [Routes.transactions.toPage()],
  TabIndex.settings: [Routes.settings.toPage()],
};

final Map<TabIndex, ValueNotifier<NavPages>> controllers = {
  TabIndex.home: ValueNotifier([Routes.home.toPage()]),
  TabIndex.transactions: ValueNotifier([Routes.transactions.toPage()]),
  TabIndex.settings: ValueNotifier([Routes.settings.toPage()]),
};

//------------------------------------------------
class NavigationState {
  final TabIndex currentTab;
  final Map<TabIndex, NavPages> stacks;

  NavigationState({
    required this.currentTab,
    required this.stacks,
  });

  NavigationState copyWith({
    TabIndex? currentTab,
    Map<TabIndex, NavPages>? stacks,
  }) {
    return NavigationState(
      currentTab: currentTab ?? this.currentTab,
      stacks: stacks ?? this.stacks,
    );
  }
}

//------------------------------------------------
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit()
      : super(
          NavigationState(
            currentTab: TabIndex.home,
            stacks: {
              TabIndex.home: [Routes.home.toPage()],
              TabIndex.transactions: [Routes.transactions.toPage()],
            },
          ),
        );

  void push(Page<Object?> page, {TabIndex? tab}) {
    final stack = NavPages.from(controllers[tab ?? state.currentTab]!.value);
    stack.add(page);
    controllers[tab ?? state.currentTab]!.value = stack;
    emit(
      state.copyWith(stacks: {...state.stacks, (tab ?? state.currentTab): stack}, currentTab: tab),
    );
  }

  void pushReplace(Page<Object?> page, {TabIndex? tab}) {
    final stack = List<Page<Object?>>.from(state.stacks[tab]!);
    if (stack.isNotEmpty) stack.removeLast();
    stack.add(page);
    replaceStack(stack, tab: (tab ?? state.currentTab));
  }

  bool canPop({TabIndex? tab}) => state.stacks[tab ?? state.currentTab]!.length > 1;

  void pop({TabIndex? tab}) {
    final stack = NavPages.from(controllers[tab ?? state.currentTab]!.value);
    if (stack.length > 1) {
      stack.removeLast();
      controllers[tab ?? state.currentTab]!.value = stack;
      emit(state
          .copyWith(stacks: {...state.stacks, (tab ?? state.currentTab): stack}, currentTab: tab));
    }
  }

  void popUntil(Page<Object?> page, bool Function(Page<Object?>) predicate, {TabIndex? tab}) {
    final stack = NavPages.from(state.stacks[tab]!);
    while (stack.isNotEmpty && !predicate(stack.last)) {
      stack.removeLast();
    }
    replaceStack(stack, tab: (tab ?? state.currentTab));
  }

  void replaceStack(NavPages pages, {TabIndex? tab}) {
    controllers[tab]!.value = pages;
    emit(
      state.copyWith(stacks: {...state.stacks, (tab ?? state.currentTab): pages}, currentTab: tab),
    );
  }

  void switchTab(TabIndex tab) {
    emit(state.copyWith(currentTab: tab));
  }

  void resetTab(TabIndex tab) {
    final newStack = [Routes.values[tab.index].toPage()];
    controllers[tab]!.value = newStack;
    emit(state.copyWith(stacks: {...state.stacks, tab: newStack}, currentTab: tab));
  }
}
