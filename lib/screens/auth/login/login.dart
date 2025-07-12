import 'package:careerwill/screens/auth/login/provider/user_provider.dart';
import 'package:careerwill/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: (loginData) {
        Provider.of<UserProvider>(context, listen: false).login(loginData);
        return null;
      },
      onSubmitAnimationCompleted: () {
        if (Provider.of<UserProvider>(
              context,
              listen: false,
            ).getLoginUsr()?.id !=
            null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const HomeScreen();
              },
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const LoginPage();
              },
            ),
          );
        }
      },
      onRecoverPassword: (_) => null,
    );
  }
}
