import 'package:careerwill/screens/auth/login/login.dart';
import 'package:careerwill/screens/auth/login/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Will',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
