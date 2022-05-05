import 'package:flutter/material.dart';
import 'package:payfren/models/payment.dart';
import 'package:payfren/theme.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({Key? key, required this.cardTransaction})
      : super(key: key);

  final Payment cardTransaction;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        decoration: BoxDecoration(
            color: Colors.white12, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Column(children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text("Date: " + cardTransaction.date,
                    style: PayfrenTheme.textTheme.bodyText1),
              ),
              const Spacer()
            ]),
            const Spacer(),
            Column(
              children: [
                const Spacer(),
                Text(
                  "Payment to " + cardTransaction.paidTo,
                  style: PayfrenTheme.textTheme.bodyText1,
                ),
                Text(
                  "-" +
                      cardTransaction.amount.toString() +
                      " BTC",
                  style: PayfrenTheme.textTheme.bodyText1,
                ),
                const Spacer()
              ],
            ),
            const Spacer()
          ],
        ));
  }
}
