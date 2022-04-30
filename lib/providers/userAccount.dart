import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:payfren/api/client.dart';
import 'package:flutter/material.dart';
import 'package:payfren/config.dart';
import 'package:payfren/data/store.dart';
import 'package:payfren/models/userProfile.dart';
import 'package:payfren/providers/auth.dart';
import 'package:provider/provider.dart';

class UserData extends ChangeNotifier {
  UserProfile? _user;
  UserProfile? get user => _user;

  List<UserProfile> _profileEntries = [];

  Future<void> getProfile() async {
    try {
      final cached = await Store.get("session");
      final userid = Session.fromMap(json.decode(cached)).userId;
      var loggedUser = await ApiClient.database.listDocuments(collectionId: Config.profileCollectionID, queries: [Query.equal("userID", userid)]);
      _profileEntries = loggedUser.documents.map((document) => UserProfile.fromJson(document.data)).toList();
      _user = _profileEntries[0];
    }on AppwriteException catch (e) {
      print(e.message);
    }
  }
}
