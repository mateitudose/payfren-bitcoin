import 'package:appwrite/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payfren/api/client.dart';
import 'package:payfren/data/store.dart';
import 'package:payfren/providers/auth.dart';
import 'package:payfren/theme.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key, required this.accountUser}) : super(key: key);

  final user accountUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(accountUser.userPhoto),
              radius: 40,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              accountUser.firstName + " " + accountUser.lastName.toString(),
              style: PayfrenTheme.textTheme.bodyText2,
            ),
            MaterialButton(
              child: const Text("Log out"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.orange,
              onPressed: () async {
                  context.read<AccountProvider>().logout();
                  Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
