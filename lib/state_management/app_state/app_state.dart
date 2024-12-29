import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// go_router_builderの画面遷移と連動してValueNotifierの生存期間を管理するDIコンテナ
/// 複数画面で状態を共有させたい時はGoRouteDataの画面遷移をネストさせて親のGoRouteDataを渡す
class AppState {
  AppState._internal();
  static final AppState instance = AppState._internal();
  factory AppState() => instance;

  static const _defaultKey = "::DEFAULT_KEY";

  final _cache = <String, Map<Type, WeakReference<ValueNotifier<dynamic>>>>{};

  ValueNotifier<T> get<T>(
      GoRouterState screen,
      ValueNotifier<T> Function() builder,
      {String? key}
      ) {
    final manageKey = (screen.path ?? "") + (key ?? _defaultKey);
    return _cache
        .putIfAbsent(manageKey, () => {})
        .putIfAbsent(T.runtimeType, () => WeakReference(builder()))
        .target as ValueNotifier<T>;
  }

  void debugPrintCache() {
    for (var entry in _cache.entries) {
      print('Key: ${entry.key}, Types: ${entry.value.keys}');
    }
  }
}