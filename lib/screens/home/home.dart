import 'package:careerwill/screens/auth/login/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider uProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("email: ${uProvider.getLoginUsr()!.email.toString()}"),
            Text("Name: ${uProvider.getLoginUsr()!.name.toString()}"),
            Text("Role: ${uProvider.getLoginUsr()!.role.toString()}"),
          ],
        ),
      ),
    );
  }
}
