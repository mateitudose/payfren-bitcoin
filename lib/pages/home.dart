import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payfren/models/userProfile.dart';
import 'package:payfren/pages/account.dart';
import 'package:payfren/providers/userAccount.dart';
import 'package:payfren/theme.dart';
import 'package:payfren/widgets/listOfPayments.dart';
import 'package:payfren/widgets/recentlyPaid.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/popover.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future recentlyPaidFuture, paymentsFuture;
  late UserProfile data;
  late UserProfile? userProfile;
  final TextEditingController _username = TextEditingController();

  @override
  void initState() {
    super.initState();
    recentlyPaidFuture = _getRecentlyPaidFuture();
    paymentsFuture = _getPayments();
  }

  _getRecentlyPaidFuture() async {
    return await UserData().getRecentlyPaid();
  }

  _getPayments() async {
    return await UserData().getPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text("Payfren", style: PayfrenTheme.textTheme.headline1),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const AccountPage(),
                  ),
                );
              },
              icon: const Icon(Icons.account_circle),
              iconSize: 36,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Text("Recently paid contacts",
                      style: PayfrenTheme.textTheme.headline2),
                ],
              ),
            ),
            FutureBuilder(
                future: recentlyPaidFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final recentUsers = snapshot.data;
                    return SizedBox(
                      height: 100,
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              RecentlyPaid(paidContact: recentUsers[index]),
                          separatorBuilder: (context, _) =>
                              const SizedBox(width: 5),
                          itemCount: recentUsers.length),
                    );
                  } else if (snapshot.hasError &&
                      snapshot.error.toString() == "Bad state: No element") {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: Text("Try paying a friend...",
                            style: PayfrenTheme.textTheme.headline2),
                      ),
                    );
                  }
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                }),
            const SizedBox(height: 14),
            Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white12),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: _username,
                onSubmitted: (value) async {
                  _username.clear();
                  userProfile =
                      await Provider.of<UserData>(context, listen: false)
                          .getUserProfile(value);
                  if (userProfile == null) {
                    const snackbar =
                        SnackBar(content: Text("User name not found"));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else {
                    data = userProfile!;
                    Timer(
                        const Duration(milliseconds: 350), handleAvatarPressed);
                  }
                },
                decoration: InputDecoration(
                    isCollapsed: true,
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white10)),
                    hintText: "username",
                    hintStyle: PayfrenTheme.textTheme.bodyText2,
                    prefixIcon: const Icon(Icons.search, color: Colors.white)),
                style: PayfrenTheme.textTheme.bodyText2,
                cursorColor: Colors.white12,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text("Latest payments",
                    style: PayfrenTheme.textTheme.headline2),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: FutureBuilder(
                  future: paymentsFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final payments = snapshot.data;
                      return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) =>
                              PaymentCard(cardTransaction: payments[index]),
                          separatorBuilder: (context, _) =>
                              const SizedBox(width: 5),
                          itemCount: payments.length);
                    } else if (snapshot.data == null) {
                      return Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            const Icon(
                              Icons.currency_bitcoin_rounded,
                              color: Colors.grey,
                              size: 100,
                            ),
                            Text(
                              "Make some payments!",
                              style: PayfrenTheme.textTheme.headline2,
                            )
                          ]));
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                        strokeWidth: 3,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void handleAvatarPressed() {
    TextEditingController _amount = TextEditingController();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Popover(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 6,
                ),
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(data.userPhoto),
                  radius: 38,
                ),
                const SizedBox(height: 6),
                Text("Pay " + data.name,
                    style: PayfrenTheme.textTheme.bodyText2),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 210,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white12),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 1,
                        controller: _amount,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            isCollapsed: true,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white10)),
                            hintText: "Bitcoin amount",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.currency_bitcoin_outlined,
                                color: Colors.white)),
                        style: PayfrenTheme.textTheme.bodyText2,
                        cursorColor: Colors.white12,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        fixedSize: const Size(45, 45),
                        shape: const CircleBorder(),
                      ),
                      onPressed: () async {
                        final amount = _amount.text;
                        String uriClassic = "bitcoin:";
                        String uriLedgerLive = "ledgerlive://send?currency=btc&recipient=";
                        uriClassic = uriClassic + data.btcAddress + "?amount=" + amount;
                        uriLedgerLive = uriLedgerLive + data.btcAddress + "&amount=" + amount;
                        try {
                          await launchUrlString(uriLedgerLive);
                          print(uriLedgerLive);
                          Navigator.of(context).pop();
                          return;
                        } catch (e) {
                          await launchUrlString(uriClassic);
                          Navigator.of(context).pop();
                          return;
                        }
                      },
                      child: const Icon(
                        Icons.send,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
