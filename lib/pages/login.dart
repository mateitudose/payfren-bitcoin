import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:payfren/pages/home.dart';
import 'package:payfren/providers/auth.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/payfren.png",
            width: 100,
          ),
          Text(
            "Payfren",
            style: PayfrenTheme.textTheme.headline1,
          ),
          Text(
            "Log in to continue",
            style: PayfrenTheme.textTheme.headline2,
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            height: 45,
            margin: const EdgeInsets.only(right: 16, left: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white12),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _email,
              decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white10)),
                  hintText: "Email",
                  hintStyle: PayfrenTheme.textTheme.bodyText2,
                  prefixIcon: const Icon(Icons.email, color: Colors.white)),
              style: PayfrenTheme.textTheme.bodyText2,
              cursorColor: Colors.white12,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            height: 45,
            margin: const EdgeInsets.only(right: 16, left: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white12),
            child: TextField(
              obscureText: true,
              controller: _password,
              decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white10)),
                  hintText: "Password",
                  hintStyle: PayfrenTheme.textTheme.bodyText2,
                  prefixIcon: const Icon(Icons.password, color: Colors.white)),
              style: PayfrenTheme.textTheme.bodyText2,
              cursorColor: Colors.white12,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          MaterialButton(
            minWidth: 100,
            height: 40,
            child: const Text(
              "Log in",
              style: TextStyle(fontSize: 16),
            ),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.orange,
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final api = context.read<AccountProvider>();
              final email = _email.text;
              final password = _password.text;

              if (email.isEmpty || password.isEmpty) {
                const snackbar =
                    SnackBar(content: Text("Please type in your credentials"));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                return;
              }
              final error = await api.login(email, password);
              if (error != null) {
                final snackbar = SnackBar(content: Text(error));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                return;
              }
            },
          ),
          const SizedBox(
            height: 75,
          ),
          Text(
            "Don't have an account?",
            style: PayfrenTheme.textTheme.headline2,
          ),
          const SizedBox(
            height: 8,
          ),
          MaterialButton(
            minWidth: 100,
            height: 40,
            child: const Text(
              "Create a new account",
              style: TextStyle(fontSize: 16),
            ),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.orange,
            onPressed: () {
              print("Create account...");
            },
          ),
        ],
      ),
    );
  }
}
