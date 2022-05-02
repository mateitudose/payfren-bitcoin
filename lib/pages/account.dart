import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payfren/models/userProfile.dart';
import 'package:payfren/providers/auth.dart';
import 'package:payfren/providers/userAccount.dart';
import 'package:payfren/theme.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Future accountFuture;

  @override
  void initState() {
    super.initState();
    accountFuture = _getAccountProfile();
  }

  _getAccountProfile() async {
    return await UserData().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: accountFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final UserProfile loggedUser = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.black12,
            appBar: AppBar(
              backgroundColor: Colors.black12,
            ),
            body: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(loggedUser.userPhoto),
                    radius: 40,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    loggedUser.name,
                    style: PayfrenTheme.textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    "You will receive BTC in wallet:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey, fontFamily: "Outfit"),
                  ),
                  Text(
                    loggedUser.btcAddress,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey, fontFamily: "Outfit"),
                  ),
                  Spacer(),
                  MaterialButton(
                    height: 45,
                    minWidth: 100,
                    child: const Text("Log out"),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.orange,
                    onPressed: () async {
                      context.read<AccountProvider>().logout();
                      Timer(const Duration(seconds: 1), () {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    "Version 1.0",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey, fontFamily: "Outfit"),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          backgroundColor: Colors.black12,
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
