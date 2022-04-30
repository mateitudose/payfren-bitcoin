import 'package:flutter/material.dart';
import 'package:payfren/models/user.dart';
import 'package:payfren/pages/account.dart';
import 'package:payfren/testdata/users.dart';
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
                    builder: (BuildContext context) => AccountPage(),
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
            SizedBox(
              height: 100,
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      RecentlyPaid(paidContact: paidUsers[index]),
                  separatorBuilder: (context, _) => const SizedBox(width: 5),
                  itemCount: paidUsers.length),
            ),
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

// Route _createRouteAccount() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) =>
//         AccountPage(accountUser: new user(firstName: "", lastName: "Tudose", userPhoto: "https://pps.whatsapp.net/v/t61.24694-24/166398836_1139498720182178_8886763049161767648_n.jpg?ccb=11-4&oh=007af13a907ea597afedbc5f1ad2a616&oe=6274DDA1"),),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       const curve = Curves.ease;
//
//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }
