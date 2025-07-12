import 'package:careerwill/models/user.dart';
import 'package:careerwill/screens/auth/login/provider/user_provider.dart';
import 'package:careerwill/screens/home/home.dart';
import 'package:careerwill/utitlity/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      userType: LoginUserType.email,
      userValidator: (value) {
        if (value!.isEmpty) return 'Email is required';
        if (!value.contains('@')) return 'Invalid email';
        return null;
      },
      onLogin: (loginData) {
        Provider.of<UserProvider>(context, listen: false).login(loginData);
        return null;
      },
      onSubmitAnimationCompleted: () {
        UserProvider provider = Provider.of<UserProvider>(
          context,
          listen: false,
        );
        User? user = provider.getLoginUsr();

        if (user != null && user.id.isNotEmpty) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      },

      onRecoverPassword: (_) => null,
      theme: LoginTheme(
        primaryColor: AppColor.lightBlue,
        buttonTheme: const LoginButtonTheme(backgroundColor: AppColor.black),
        cardTheme: const CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        titleStyle: const TextStyle(color: Colors.black),
      ),
      children: [
        // Graduation hat top left
        Positioned(
          top: 40,
          left: 30,
          child: Icon(
            Icons.school,
            size: 60,
            color: Colors.deepPurple.withOpacity(0.1),
          ),
        ),
        // Open book top right
        Positioned(
          top: 80,
          right: 20,
          child: Icon(
            Icons.menu_book,
            size: 50,
            color: Colors.blue.withOpacity(0.1),
          ),
        ),
        // Pencil bottom left
        Positioned(
          bottom: 80,
          left: 20,
          child: Icon(
            Icons.edit,
            size: 50,
            color: Colors.deepOrange.withOpacity(0.1),
          ),
        ),
        // Graduation hat bottom right
        Positioned(
          bottom: 50,
          right: 40,
          child: Icon(
            Icons.school,
            size: 70,
            color: Colors.green.withOpacity(0.1),
          ),
        ),
        // Science icon center left
        Positioned(
          top: 200,
          left: 10,
          child: Icon(
            Icons.science,
            size: 60,
            color: Colors.cyan.withOpacity(0.3),
          ),
        ),

        // Computer center bottom
        Positioned(
          bottom: 150,
          right: 120,
          child: Icon(
            Icons.computer,
            size: 50,
            color: Colors.indigo.withOpacity(0.3),
          ),
        ),
        // Lightbulb near top
        Positioned(
          top: 20,
          right: 150,
          child: Icon(
            Icons.lightbulb,
            size: 40,
            color: Colors.yellow.withOpacity(0.3),
          ),
        ),
        // Backpack bottom center
        Positioned(
          bottom: 30,
          left: 150,
          child: Icon(
            Icons.backpack,
            size: 60,
            color: Colors.teal.withOpacity(0.3),
          ),
        ),
        // Library books center top
        Positioned(
          top: 150,
          left: 120,
          child: Icon(
            Icons.library_books,
            size: 50,
            color: Colors.brown.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
