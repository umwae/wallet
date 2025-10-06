import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/exceptions/app_exception_mapper.dart';
import 'package:stonwallet/src/feature/navdec/navdec.dart';
import 'package:stonwallet/src/feature/navdec/navigation_cubit.dart';

class DeepLinkReceived {
  final Uri uri;
  DeepLinkReceived(this.uri);
}

class DeepLinkBloc extends Bloc<DeepLinkReceived, Uri?> {
  final AppLinks _appLinks = AppLinks();
  final NavigationCubit navigationCubit;
  StreamSubscription<Uri?>? _sub;

  final _transfer = 'transfer';

  DeepLinkBloc(this.navigationCubit) : super(null) {
    on<DeepLinkReceived>((event, emit) {
      _handleDeepLink(event.uri);
      emit(event.uri);
    });

    _init();
  }

  Future<void> _init() async {
    // Пробуем получить initial link если открыли приложение через ссылку
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        add(DeepLinkReceived(initial));
      }
    } catch (e) {
      debugPrint('[DBG] getInitialLink failed: $e');
    }
    // Подписываемся на поток всех будущих ссылок
    // uriLinkStream уже покрывает initial + последующие,
    // но вызов getInitialLink выше делает поведение надежнее в разных средах
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        add(DeepLinkReceived(uri));
      },
      onError: (Object e, StackTrace st) {
        Error.throwWithStackTrace(e.toAppException(), st);
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    if (uri.scheme == 'ton') {
      if (uri.host.contains(_transfer)) {
        _parseTransfer(uri);
      }
    }
  }

  void _parseTransfer(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.length == 1 && segments[0].isNotEmpty) {
      navigationCubit.switchTab(TabIndex.home);
      navigationCubit.resetTab(TabIndex.home);
      navigationCubit.push(Routes.confirmSending.toPage(arguments: {'address': segments[0]}));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
