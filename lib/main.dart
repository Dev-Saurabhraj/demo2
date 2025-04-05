
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swaasthi/provider/change_provider.dart';

import 'Router/router_navigation.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await Hive.initFlutter();

  // Open a Hive box
  await Hive.openBox('authBox');

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context)=>AppProvider())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: GoRoutes.router,
      ),
    );
  }
}
