import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:payfren/api/client.dart';
import 'package:flutter/material.dart';
import 'package:payfren/config.dart';
import 'package:payfren/data/store.dart';
import 'package:payfren/models/payment.dart';
import 'package:payfren/models/userID.dart';
import 'package:payfren/models/userProfile.dart';
import 'package:intl/intl.dart';

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
        if (awaitProfile.documents.isEmpty) continue;
        _profile = awaitProfile.documents
            .map((document) => UserProfile.fromJson(document.data))
            .toList();
        _userProfile = _profile[0];
        _listOfRecentlyPaid.add(_userProfile);
      }

      return _listOfRecentlyPaid;
    } on AppwriteException catch (e) {
      return null;
    }
  }

  Future<UserProfile?> getUserProfile(String userName) async {
    List<UserProfile> profile;
    UserProfile? userProfile;

    final cached = await Store.get("session");
    final userid = Session.fromMap(json.decode(cached)).userId;

    var awaitProfile = await ApiClient.database.listDocuments(
        collectionId: Config.profileCollectionID,
        queries: [Query.equal("userName", userName)]);
    profile = awaitProfile.documents
        .map((document) => UserProfile.fromJson(document.data))
        .toList();
    if (profile.isEmpty) {
      return null;
    }
    userProfile = profile[0];

    if (userProfile.userID == userid) {
      return null;
    }
    return userProfile;
  }

  Future<List<Payment>?> getPayments() async {
    List<Payment> paymentsUser;

    final cached = await Store.get("session");
    final userid = Session.fromMap(json.decode(cached)).userId;

    var awaitPayments = await ApiClient.database.listDocuments(
        collectionId: Config.paymentsID,
        queries: [Query.equal('userID', userid)]);
    paymentsUser = awaitPayments.documents
        .map((document) => Payment.fromJson(document.data))
        .toList();

    if (paymentsUser.isEmpty) return null;

    return paymentsUser;
  }

  Future<String?> pushPayment(String paidTo, String amount) async {
    final cached = await Store.get("session");
    final userid = Session.fromMap(json.decode(cached)).userId;
    final now = DateTime.now();
    String dateString = DateFormat('dd-MM-yyyy').format(now);
    final addPayment = Payment(
        userID: userid,
        paidTo: paidTo,
        amount: amount,
        date: dateString);
    try {
      await ApiClient.database.createDocument(
          collectionId: Config.paymentsID,
          documentId: 'unique()',
          data: addPayment.toMap());
      return null;
    } on AppwriteException catch (e) {
      return e.message;
    }
  }
}
