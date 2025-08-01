import 'package:careerwill/screens/auth/login/login.dart';
import 'package:careerwill/screens/auth/login/provider/user_provider.dart';
import 'package:careerwill/screens/home/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Will',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
