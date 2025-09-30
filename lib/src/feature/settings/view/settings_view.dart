import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/initialization/model/app_theme.dart';
import 'package:stonwallet/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:stonwallet/src/feature/settings/model/app_settings.dart';
import 'package:stonwallet/src/feature/settings/widget/settings_scope.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки'), centerTitle: true),
      body: SafeArea(
        child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
          bloc: SettingsScope.of(context, listen: false),
          builder: (BuildContext context, AppSettingsState state) {
            final settings = state.appSettings ?? const AppSettings();
            final appTheme = settings.appTheme ?? AppTheme.defaultTheme;
            final currentThemeMode = appTheme.themeMode;

            return ListTile(
              title: const Text('Тема приложения'),
              trailing: SegmentedButton<ThemeMode>(
                // style: SegmentedButton.styleFrom(),
                segments: const <ButtonSegment<ThemeMode>>[
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode),
                    label: Text('Светлая'),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode),
                    label: Text('Темная'),
                  ),
                  // ButtonSegment<ThemeMode>(
                  //   value: ThemeMode.system,
                  //   icon: Icon(Icons.auto_mode),
                  //   label: Text('Авто'),
                  // ),
                ],
                selected: <ThemeMode>{currentThemeMode},
                onSelectionChanged: (Set<ThemeMode> newSelection) {
                  final newThemeMode = newSelection.first;
                  final newAppTheme = appTheme.copyWith(themeMode: newThemeMode);
                  final newSettings = settings.copyWith(appTheme: newAppTheme);
                  SettingsScope.of(context, listen: false)
                      .add(AppSettingsEvent.updateAppSettings(appSettings: newSettings));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
