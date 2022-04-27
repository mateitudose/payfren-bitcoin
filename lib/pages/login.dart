import 'package:flutter/material.dart';
import 'package:payfren/pages/home.dart';
import '../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Payfren",
          style: PayfrenTheme.textTheme.headline1,
        ),
        Text(
          "Login to your account",
          style: PayfrenTheme.textTheme.headline2,
        ),
        const SizedBox(
          height: 16,
        ),

      ],
    );
  }
}
