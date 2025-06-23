import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stonwallet/src/core/utils/layout/window_size.dart';
import 'package:stonwallet/src/feature/auth/bloc/auth_bloc.dart';
import 'package:stonwallet/src/feature/auth/guard/auth_guard.dart';
import 'package:stonwallet/src/feature/home/view/home_screen.dart';
import 'package:stonwallet/src/feature/initialization/logic/composition_root.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/feature/initialization/widget/material_context.dart';
import 'package:stonwallet/src/feature/login/login.dart';
import 'package:stonwallet/src/feature/navdec/navdec.dart';
import 'package:stonwallet/src/feature/settings/widget/settings_scope.dart';
import 'package:user_repository/user_repository.dart';

/// {@template app}
/// [App] is an entry point to the application.
///
/// If a scope doesn't depend on any inherited widget returned by
/// [MaterialApp] or [WidgetsApp], like [Directionality] or [Theme],
/// and it should be available in the whole application, it can be
/// placed here.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({required this.result, super.key});

  /// The result from the [CompositionRoot].
  final CompositionResult result;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(),
          dispose: (repository) => repository.dispose(),
        ),
        RepositoryProvider(create: (_) => UserRepository()),
      ],
      child: BlocProvider(
        lazy: false,
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
        )..add(AuthSubscriptionRequested()),
        child: DefaultAssetBundle(
          bundle: SentryAssetBundle(),
          child: DependenciesScope(
            dependencies: result.dependencies,
            child: const SettingsScope(
              child: WindowSizeScope(child: AppView()),
            ),
          ),
        ),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  // final GlobalKey<State<StatefulWidget>> _preserveKey = GlobalKey<State<StatefulWidget>>();
  // final debugObserver = DebugObserver();

  @override
  Widget build(BuildContext context) => MaterialContext(
        // title: 'Declarative Navigation',
        // debugShowCheckedModeBanner: true,
        // builder: (context, state) {
        //   return AppNavigator(
        //     key: _preserveKey,
        //     pages: const [MaterialPage<void>(child: LoginPage())],
        //     observers: [debugObserver],
        //     guards: [
        //       // authGuard(authState)
        //     ],
        //   );
        // },
      );
}
