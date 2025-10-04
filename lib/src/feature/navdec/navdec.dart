/*
 * Declarative Navigation
 * A simple declarative navigation system for Flutter.
 * https://gist.github.com/PlugFox/aaa2a1ab4ab71b483b736530ebb03894
 * https://dartpad.dev?id=aaa2a1ab4ab71b483b736530ebb03894
 * Mike Matiunin <plugfox@gmail.com>, 14 March 2025
 */

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/widget/main_navigation_bar.dart';
import 'package:stonwallet/src/feature/counter/counter.dart';
import 'package:stonwallet/src/feature/current_detail/current_detail.dart';
import 'package:stonwallet/src/feature/home/bloc/home_scope.dart';
import 'package:stonwallet/src/feature/login/view/login_page.dart';
import 'package:stonwallet/src/feature/navdec/navigation_cubit.dart';
import 'package:stonwallet/src/feature/navdec/animated_page.dart';
import 'package:stonwallet/src/feature/receive/view/receive_view.dart';
import 'package:stonwallet/src/feature/send/confirm_sending_scope.dart';
import 'package:stonwallet/src/feature/send/scanner.dart';
import 'package:stonwallet/src/feature/settings/view/settings_view.dart';
import 'package:stonwallet/src/feature/transactions/cubit/transactions_scope.dart';

/// Type definition for the navigation state.
typedef NavPages = List<Page<Object?>>;

/// {@template navigator}
/// AppNavigator widget.
/// {@endtemplate}
class AppNavigator extends StatefulWidget {
  /// {@macro navigator}
  AppNavigator({
    required this.pages,
    this.guards = const [],
    this.observers = const [],
    this.transitionDelegate = const DefaultTransitionDelegate<Object?>(),
    this.revalidate,
    this.onBackButtonPressed,
    super.key,
  })  : assert(pages.isNotEmpty, 'pages cannot be empty'),
        controller = null;

  /// {@macro navigator}
  AppNavigator.controlled({
    required ValueNotifier<NavPages> this.controller,
    this.guards = const [],
    this.observers = const [],
    this.transitionDelegate = const DefaultTransitionDelegate<Object?>(),
    this.revalidate,
    this.onBackButtonPressed,
    super.key,
  })  : assert(controller.value.isNotEmpty, 'controller cannot be empty'),
        pages = controller.value;

  /// The [AppNavigatorState] from the closest instance of this class
  /// that encloses the given context, if any.
  static AppNavigatorState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<AppNavigatorState>();

  /// The navigation state from the closest instance of this class
  /// that encloses the given context, if any.
  static NavPages? stateOf(BuildContext context) => maybeOf(context)?.state;

  /// The navigator from the closest instance of this class
  /// that encloses the given context, if any.
  static NavigatorState? navigatorOf(BuildContext context) => maybeOf(context)?.navigator;

  /// Change the pages.
  static void change(
    BuildContext context,
    NavPages Function(NavPages pages) fn,
  ) =>
      maybeOf(context)?.change(fn);

  /// Add a page to the stack.
  static void push(BuildContext context, Page<Object?> page) =>
      change(context, (state) => [...state, page]);

  /// Pop the last page from the stack.
  static void pop(BuildContext context) => change(context, (state) {
        if (state.isNotEmpty) state.removeLast();
        return state;
      });

  /// Clear the pages to the initial state.
  static void reset(BuildContext context, Page<Object?> page) {
    final navigator = maybeOf(context);
    if (navigator == null) return;
    navigator.change((_) => navigator.widget.pages);
  }

  /// The back button handler to use for the navigator.
  final NavPages Function(NavPages)? onBackButtonPressed;

  /// Initial pages to display.
  final NavPages pages;

  /// The controller to use for the navigator.
  final ValueNotifier<NavPages>? controller;

  /// Guards to apply to the pages.
  final List<NavPages Function(NavPages)> guards;

  /// Observers to attach to the navigator.
  final List<NavigatorObserver> observers;

  /// The transition delegate to use for the navigator.
  final TransitionDelegate<Object?> transitionDelegate;

  /// Revalidate the pages.
  final Listenable? revalidate;

  @override
  State<AppNavigator> createState() => AppNavigatorState();
}

/// State for widget AppNavigator.
class AppNavigatorState extends State<AppNavigator> with WidgetsBindingObserver {
  /// The current [Navigator] state (null if not yet built).
  NavigatorState? get navigator => _observer.navigator;

  /// The current pages list.
  NavPages get state => _state;

  late NavPages _state;
  final NavigatorObserver _observer = NavigatorObserver();
  List<NavigatorObserver> _observers = const [];

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    _state = widget.pages;
    widget.revalidate?.addListener(revalidate);
    _observers = <NavigatorObserver>[_observer, ...widget.observers];
    widget.controller?.addListener(_controllerListener);
    _controllerListener();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant AppNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.revalidate, oldWidget.revalidate)) {
      oldWidget.revalidate?.removeListener(revalidate);
      widget.revalidate?.addListener(revalidate);
    }
    if (!identical(widget.observers, oldWidget.observers)) {
      _observers = <NavigatorObserver>[_observer, ...widget.observers];
    }
    if (!identical(widget.controller, oldWidget.controller)) {
      oldWidget.controller?.removeListener(_controllerListener);
      widget.controller?.addListener(_controllerListener);
      _controllerListener();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_controllerListener);
    widget.revalidate?.removeListener(revalidate);
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<bool> didPopRoute() {
    // If the back button handler is defined, call it.
    final backButtonHandler = widget.onBackButtonPressed;
    if (backButtonHandler != null) {
      final result = backButtonHandler(_state.toList());
      change((pages) => result);
      return SynchronousFuture(true);
    }

    // Otherwise, handle the back button press with the default behavior.
    if (_state.length < 2) return SynchronousFuture(false);
    _onDidRemovePage(_state.last);
    return SynchronousFuture(true);
  }

  /* #endregion */

  void _setStateToController() {
    if (widget.controller case final ValueNotifier<NavPages> controller) {
      controller
        ..removeListener(_controllerListener)
        ..value = _state
        ..addListener(_controllerListener);
    }
  }

  void _controllerListener() {
    final controller = widget.controller;
    if (controller == null) return;
    final newValue = controller.value;
    if (identical(newValue, _state)) return;
    final next = widget.guards.fold(newValue.toList(), (s, g) => g(s));
    if (next.isEmpty || listEquals(next, _state)) {
      _setStateToController(); // Revert the controller value.
    } else {
      _state = UnmodifiableListView<Page<Object?>>(next);
      _setStateToController();
      setState(() {});
    }
  }

  /// Revalidate the pages.
  void revalidate() {
    final next = widget.guards.fold(_state.toList(), (s, g) => g(s));
    if (next.isEmpty || listEquals(next, _state)) return;
    _state = UnmodifiableListView<Page<Object?>>(next);
    _setStateToController();
    setState(() {});
  }

  /// Change the pages.
  void change(NavPages Function(NavPages pages) fn) {
    final prev = _state.toList();
    var next = fn(prev);
    if (next.isEmpty) return;
    next = widget.guards.fold(next, (s, g) => g(s));
    if (next.isEmpty || listEquals(next, _state)) return;
    _state = UnmodifiableListView<Page<Object?>>(next);
    _setStateToController();
    setState(() {});
    // debugPrint('[DBG] New nav stack: ${_state.map((e) => e.name)}');
  }

  void _onDidRemovePage(Page<Object?> page) => change((pages) => pages..remove(page));

  @override
  Widget build(BuildContext context) => Navigator(
        pages: _state,
        reportsRouteUpdateToEngine: true,
        transitionDelegate: widget.transitionDelegate,
        onDidRemovePage: _onDidRemovePage,
        observers: _observers,
      );
}

class DebugObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('[DBG] Route popped: ${route.settings.name}');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('[DBG] Route pushed: ${previousRoute?.settings.name} -> ${route.settings.name}');
  }
}

enum Routes {
  home,
  login,
  counter,
  currentDetail,
  transactions,
  confirmSending,
  receive,
  scanner,
  settings;

  const Routes();

  /// Converts the route to a [MaterialPage].
  Page<Object?> toPage({Map<String, Object?>? arguments, LocalKey? key}) =>
      AnimatedMaterialPage<void>(
        name: name,
        arguments: arguments,
        key: switch ((key, arguments)) {
          (final LocalKey key, _) => key,
          (_, final Map<String, Object?> arguments) => ValueKey(
              '$name#${shortHash(arguments)}',
            ),
          _ => ValueKey<String>(name),
        },
        child: switch (this) {
          Routes.home => const HomeScope(),
          Routes.login => const LoginPage(),
          Routes.counter => const CounterPage(),
          Routes.currentDetail => const CurrentDetailScope(),
          Routes.transactions => const TransactionsScope(),
          Routes.receive => const ReceiveView(),
          Routes.scanner => const ScannerView(),
          Routes.confirmSending => const ConfirmSendingScope(),
          Routes.settings => const SettingsView(),
        },
      );
}

class TabNavigator extends StatelessWidget {
  TabNavigator({super.key});
  final List<NavPages Function(NavPages)> _guards = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: state.currentTab.index,
            children: TabIndex.values.map((tab) {
              return AppNavigator.controlled(
                controller: controllers[tab]!,
                guards: _guards,
                observers: [DebugObserver()],
              );
            }).toList(),
          ),
          bottomNavigationBar: 
          MainNavigationBar(
            currentIndex: state.currentTab.index,
            onTap: (i) => context.read<NavigationCubit>().switchTab(
                  TabIndex.values[i],
                ),
          ),
        );
      },
    );
  }
}
