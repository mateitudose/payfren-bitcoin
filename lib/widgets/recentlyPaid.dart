import 'package:flutter/material.dart';
import 'package:payfren/models/userProfile.dart';
import 'package:payfren/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:payfren/widgets/popover.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecentlyPaid extends StatefulWidget {
  const RecentlyPaid({Key? key, required this.paidContact}) : super(key: key);

  final UserProfile paidContact;

  @override
  State<RecentlyPaid> createState() => _RecentlyPaidState();
}

class _RecentlyPaidState extends State<RecentlyPaid> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Expanded(
            child: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(widget.paidContact.userPhoto),
                radius: 38,
                child: Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      handleAvatarPressed();
                    },
                  ),
                )),
          ),
          const SizedBox(height: 4),
          Text(widget.paidContact.name, style: PayfrenTheme.textTheme.bodyText1)
        ],
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
                  backgroundImage:
                      CachedNetworkImageProvider(widget.paidContact.userPhoto),
                  radius: 38,
                ),
                const SizedBox(height: 6),
                Text("Pay " + widget.paidContact.name,
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
                            prefixIcon: Icon(
                                Icons.currency_bitcoin_outlined,
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
                        String uriLedgerLive =
                            "ledgerlive://send?currency=btc?recipient=";
                        uriClassic =
                            uriClassic + widget.paidContact.btcAddress + "?amount=" + amount;
                        uriLedgerLive = uriLedgerLive +
                            widget.paidContact.btcAddress +
                            "?amount=" +
                            amount;
                        try {
                          await launchUrlString(uriLedgerLive);
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
