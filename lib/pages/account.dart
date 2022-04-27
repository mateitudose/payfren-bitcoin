import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payfren/theme.dart';
import '../models/user.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key, required this.accountUser}) : super(key: key);

  final User accountUser;

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
              onPressed: () {
                Navigator.of(context).pop();
                print("Logging out...");
              },
            )
          ],
        ),
      ),
    );
  }
}
