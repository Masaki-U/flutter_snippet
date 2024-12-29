import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// go_router_builderの画面遷移と連動してValueNotifierの生存期間を管理するDIコンテナ
class AppState {
  AppState._internal();
  static final AppState instance = AppState._internal();
  factory AppState() => instance;

  static const _defaultKey = "::DEFAULT_KEY";

  final _cache = <String, Map<Type, ValueNotifier<dynamic>>>{};
  final _refCount = <String, _Counter>{};

  ValueNotifier<T> get<T>(
      GoRouterState screen,
      ValueNotifier<T> Function() builder,
      {String? key}
      ) {
    final manageKey = (screen.path ?? "") + (key ?? _defaultKey);
    _refCount.putIfAbsent(manageKey, () => _Counter()).inc(screen);
    return _cache.putIfAbsent(manageKey, () => {}).putIfAbsent(T.runtimeType,  builder) as ValueNotifier<T>;
  }

  void _remove(
      GoRouterState screen,
      String? key) {
    final manageKey = (screen.path ?? "") + (key ?? _defaultKey);
    _refCount[manageKey]?.dec(screen, () {
      _cache.remove(manageKey);
    });
  }
}

/// 戻る処理でアプリ上から消える時にDIコンテナに通知を行うGoRouteData
abstract class AppStateRoute extends GoRouteData {
  const AppStateRoute(this.paramKey);

  final String? paramKey;

  @override
  FutureOr<bool> onExit(BuildContext context, GoRouterState state) {
    if (state.pageKey.value == GoRouter.of(context).routerDelegate.currentConfiguration.matches.lastOrNull?.pageKey.value) {
      AppState()._remove(state, paramKey);
    }
    return super.onExit(context, state);
  }
}

/// GoRouterStateを参照カウントして状態クラスの削除タイミングを管理するデータクラス
class _Counter {
  final _ref = <GoRouterState>{};

  void inc(GoRouterState screen) {
    _ref.add(screen);
  }

  void dec(GoRouterState screen, void Function() callback) {
    _ref.remove(screen);
    if (_ref.isEmpty) {
      callback();
    }
  }
}
