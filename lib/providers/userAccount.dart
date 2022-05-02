import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:payfren/api/client.dart';
import 'package:flutter/material.dart';
import 'package:payfren/config.dart';
import 'package:payfren/data/store.dart';
import 'package:payfren/models/userID.dart';
import 'package:payfren/models/userProfile.dart';

class UserData extends ChangeNotifier {
  UserProfile? _user;
  UserProfile? get user => _user;

  PaidUserIDs? _paidUsersIDs;
  PaidUserIDs? get paidUsersIDs => _paidUsersIDs;

  List<UserProfile> _profileEntries = [];

  Future<UserProfile?> getProfile() async {
    try {
      final cached = await Store.get("session");
      final userid = Session.fromMap(json.decode(cached)).userId;
      var loggedUser = await ApiClient.database.listDocuments(
          collectionId: Config.profileCollectionID,
          queries: [Query.equal("userID", userid)]);
      _profileEntries = loggedUser.documents
          .map((document) => UserProfile.fromJson(document.data))
          .toList();
      _user = _profileEntries[0];
      _profileEntries.clear();
      notifyListeners();
      return _user;
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<List<UserProfile>?> getRecentlyPaid() async {
    List<UserProfile> _listOfRecentlyPaid = [], _profile;
    UserProfile _userProfile;

    try {
      final cached = await Store.get("session");
      final userid = Session.fromMap(json.decode(cached)).userId;
      var paidUsers = await ApiClient.database.listDocuments(
          collectionId: Config.recentlyPaidID,
          queries: [Query.equal("userID", userid)]);
      _paidUsersIDs = paidUsers.documents
          .map((document) => PaidUserIDs.fromJson(document.data))
          .first;

      for (String person in _paidUsersIDs?.paid ?? []) {
        var awaitProfile = await ApiClient.database.listDocuments(
            collectionId: Config.profileCollectionID,
            queries: [Query.equal("userID", person)]);
        _profile = awaitProfile.documents
            .map((document) => UserProfile.fromJson(document.data))
            .toList();
        _userProfile = _profile[0];
        _listOfRecentlyPaid.add(_userProfile);
      }

      return _listOfRecentlyPaid;
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }
}
