import 'package:flutter/material.dart';
import 'package:home_asset_management/core/helpers/hive.dart';
import 'package:home_asset_management/modules/homes/presentation/views/homes_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeHive();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Asset Management',
      navigatorKey: navigatorKey,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const HomesView(),
    );
  }
}
