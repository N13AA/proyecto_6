import 'package:flutter/material.dart';
import 'package:proyecto_6/app/ui/routes/pages.dart';
import 'package:proyecto_6/app/ui/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
    
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
          initialRoute: Routes.SPLASH,
          routes: appRoutes(),
    );
  }
}


