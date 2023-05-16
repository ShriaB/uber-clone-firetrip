import 'package:firebase_core/firebase_core.dart';
import 'package:firetrip/common/routes/routes.dart';
import 'package:flutter/material.dart';

import 'package:firetrip/common/routes/route_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  runApp(const ProviderScope(child: MyApp()));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouteNames.splash,
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
