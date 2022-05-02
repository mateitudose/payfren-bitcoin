import 'package:flutter/material.dart';
import 'package:payfren/pages/account.dart';
import 'package:payfren/providers/userAccount.dart';
import 'package:payfren/testdata/payments.dart';
import 'package:payfren/theme.dart';
import 'package:payfren/widgets/listOfPayments.dart';
import 'package:payfren/widgets/recentlyPaid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future recentlyPaidFuture;

  @override
  void initState() {
    super.initState();
    recentlyPaidFuture = _getRecentlyPaidFuture();
  }

  _getRecentlyPaidFuture() async {
    return await UserData().getRecentlyPaid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  }
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.orange, strokeWidth: 3,),
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
                decoration: InputDecoration(
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
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) =>
                        PaymentCard(cardTransaction: userTXs[index]),
                    separatorBuilder: (context, _) =>
                        const SizedBox(height: 14),
                    itemCount: userTXs.length))
          ],
        ),
      ),
    );
  }
}
