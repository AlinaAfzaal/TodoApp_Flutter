
import 'package:flutter/material.dart';
import 'package:todo_app/pages/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/providers/home_page_provider.dart';
import 'database/db_connection.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseConnection().database;
  runApp(
      ChangeNotifierProvider(
          create: (context)=>HomePageProvider(),
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0AB6AB)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

