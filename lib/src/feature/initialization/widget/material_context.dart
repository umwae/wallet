import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:stonwallet/src/core/constant/localization/localization.dart';
import 'package:stonwallet/src/feature/counter/counter.dart';
import 'package:stonwallet/src/feature/home/view/home_screen.dart';
import 'package:stonwallet/src/feature/initialization/model/app_theme.dart';
import 'package:stonwallet/src/feature/login/view/login_page.dart';
import 'package:stonwallet/src/feature/navdec/navdec.dart';
import 'package:stonwallet/src/feature/settings/widget/settings_scope.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class MaterialContext extends StatelessWidget {
  /// {@macro material_context}
  MaterialContext({super.key});

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> _preserveKey = GlobalKey<State<StatefulWidget>>();
  final debugObserver = DebugObserver();

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.settingsOf(context);
    final mediaQueryData = MediaQuery.of(context);

    return MaterialApp(
      theme: settings.appTheme?.lightTheme ?? AppTheme.defaultTheme.lightTheme,
      darkTheme: settings.appTheme?.darkTheme ?? AppTheme.defaultTheme.darkTheme,
      themeMode: settings.appTheme?.themeMode ?? ThemeMode.system,
      locale: settings.locale,
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      title: 'Declarative Navigation',
      debugShowCheckedModeBanner: true,
      // home: CustomMaterialIndicator(
      //     clipBehavior: Clip.antiAlias,
      //     trigger: IndicatorTrigger.bothEdges,
      //     triggerMode: IndicatorTriggerMode.anywhere,
      //     onRefresh: () => Future.delayed(const Duration(seconds: 2)),
      //     // builder: (context, child, controller) =>
      //     //     DecoratedBox(decoration: const BoxDecoration(color: Colors.red), child: child),
      //     child: const LoginPage(),
      //   ),
      builder: (context, child) =>
          //Масштабирование текста
          MediaQuery(
        key: _globalKey,
        data: mediaQueryData.copyWith(
          textScaler: TextScaler.linear(
            mediaQueryData.textScaler.scale(settings.textScale ?? 1).clamp(0.5, 2),
          ),
        ),
        child: AppNavigator(
          key: _preserveKey,
          pages: const [MaterialPage<void>(child: LoginPage())],
          observers: [debugObserver],
          guards: [
            // authGuard(authState)
          ],
        ),
      ),
    );
  }
}
