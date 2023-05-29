import 'package:firebase_core/firebase_core.dart';
import 'package:firetrip/global/routes/route_names.dart';
import 'package:firetrip/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  /// Loading .env file
  await dotenv.load(fileName: "assets/config/.env");

  /// running the app
  runApp(const ProviderScope(child: MyApp()));
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Preserving the splash screen
  /// Splash screen removed after Firebase app has been initialised
  /// And after checking if user is logged in or not
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// initalising firebase
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
