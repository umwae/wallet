import 'package:flutter/material.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:stonwallet/src/feature/auth/bloc/auth_bloc.dart';
import 'package:stonwallet/src/feature/home/bloc/home_scope.dart';
import 'package:stonwallet/src/feature/login/view/login_page.dart';
import 'package:stonwallet/src/feature/navdec/navdec.dart';

NavPages Function(NavPages) authGuard(AuthState authState) {
  return (NavPages pages) {
    switch (authState.status) {
      case AuthStatus.unknown:
        // При неизвестном состоянии оставляем текущие страницы
        return pages;
      case AuthStatus.authenticated:
        // Если пользователь авторизован и находится на странице логина,
        // перенаправляем на домашний экран
        final lastPage = pages.last;
        if (lastPage is MaterialPage && lastPage.child is LoginPage) {
          return [const MaterialPage<void>(child: HomeScope())];
        }
        return pages;
      case AuthStatus.unauthenticated:
        // Если пользователь не авторизован и пытается открыть любую страницу кроме login,
        // перенаправляем на login
        final lastPage = pages.last;
        if (lastPage is MaterialPage && lastPage.child is! LoginPage) {
          return [const MaterialPage<void>(child: LoginPage())];
        }
        return pages;
    }
  };
}