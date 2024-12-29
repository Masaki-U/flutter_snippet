import 'package:flutter/material.dart';
import 'package:flutter_snippet/state_management/app_state/app_state.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'dart:convert';
part 'example.g.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

// Define the routes using TypedGoRoute and AppStateRoute
final _router = GoRouter(
  routes: $appRoutes,
);

@TypedGoRoute<HomeRoute>(
  path: '/',
)
class HomeRoute extends GoRouteData {

  @override
  Widget build(BuildContext context, GoRouterState state) {
    _router.routerDelegate.currentConfiguration;
    // Create or retrieve the ValueNotifier for the HomePage
    final counterNotifier = AppState.instance.get<int>(
      state,
          () => ValueNotifier<int>(0),
    );
    return HomePage(counterNotifier: counterNotifier);
  }
}

@TypedGoRoute<DetailRoute>(
  path: '/detail/:id',
)
class DetailRoute extends GoRouteData {
  const DetailRoute(this.id) : super();

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // Create or retrieve the ValueNotifier for the DetailPage
    final counterNotifier = AppState.instance.get<int>(
      state,
          () => ValueNotifier<int>(0),
        key: id,
    );
    return DetailPage(counterNotifier: counterNotifier);
  }
}

// HomePage widget, receiving only ValueNotifier
class HomePage extends StatelessWidget {
  final ValueNotifier<int> counterNotifier; // Holds the ValueNotifier for the route

  const HomePage({super.key, required this.counterNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')), // App bar title
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the current counter value
            ValueListenableBuilder<int>(
              valueListenable: counterNotifier,
              builder: (context, value, child) => Text('Counter: $value'),
            ),
            ElevatedButton(
              onPressed: () {
                counterNotifier.value++; // Increment the counter
              },
              child: const Text('Increment Counter'),
            ),
            ElevatedButton(
              onPressed: () {
                const DetailRoute("dsfzv").push(context);
              },
              child: const Text('Go to Detail Page'),
            ),
          ],
        ),
      ),
    );
  }
}

// DetailPage widget, receiving only ValueNotifier
class DetailPage extends StatelessWidget {
  final ValueNotifier<int> counterNotifier; // Holds the ValueNotifier for the route

  const DetailPage({super.key, required this.counterNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Page')), // App bar title
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the current counter value for the detail page
            ValueListenableBuilder<int>(
              valueListenable: counterNotifier,
              builder: (context, value, child) => Text('Detail Counter: $value'),
            ),
            ElevatedButton(
              onPressed: () {
                counterNotifier.value++; // Increment the counter
              },
              child: const Text('Increment Detail Counter'),
            ),
            ElevatedButton(
              onPressed: () {
                DetailRoute(getRandString()).push(context);
              },
              child: const Text('Go to Detail Page'),
            ),
          ],
        ),
      ),
    );
  }
}

String getRandString() {
  var random = Random.secure();
  var values = List<int>.generate(500, (i) =>  random.nextInt(255));
  return base64UrlEncode(values);
}