import 'package:flutter/material.dart';
import 'package:payfren/models/user.dart';
import 'package:payfren/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecentlyPaid extends StatelessWidget {
  const RecentlyPaid({Key? key, required this.paidContact}) : super(key: key);

  final User paidContact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Expanded(
            child: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(paidContact.userPhoto),
              radius: 38,
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => {
                    print("Pressed on " + paidContact.name)
                  },
                ),
              )
            ),
          ),
          const SizedBox(height: 4),
          Text(paidContact.name, style: PayfrenTheme.textTheme.bodyText1)
        ],
      ),
    );
  }
}
