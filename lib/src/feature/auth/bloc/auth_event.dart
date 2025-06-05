part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}
//начальное событие, которое уведомляет блок о необходимости подписаться на AuthStatus поток
final class AuthSubscriptionRequested extends AuthEvent {}

//уведомляет блок о выходе пользователя из системы
final class AuthLogoutPressed extends AuthEvent {}