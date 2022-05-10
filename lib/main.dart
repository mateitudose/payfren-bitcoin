import 'package:flutter/material.dart';
import 'package:payfren/pages/home.dart';
import 'package:flutter/services.dart';
import 'package:payfren/pages/login.dart';
import 'package:payfren/providers/auth.dart';
import 'package:payfren/providers/userAccount.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AccountProvider()),
      ChangeNotifierProvider(create: (context) => UserData())
    ],
    child: Payfren(),
  ));
}

class Payfren extends StatelessWidget {
  const Payfren({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payfren',
      home: FutureBuilder(
        future: context.read<AccountProvider>().isValid(),
        builder: (context, snapshot) =>
            context.watch<AccountProvider>().session == null
                ? const LoginPage()
                : const HomePage(),
      ),
    );
  }
}
