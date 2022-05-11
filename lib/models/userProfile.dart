class UserProfile {
  late String name;
  late String userPhoto;
  late String btcAddress;
  late String userName;
  late String userID;

  UserProfile(
      {required this.name,
      required this.userPhoto,
      required this.btcAddress,
      required this.userName,
      required this.userID});

  UserProfile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userPhoto = json['userPhoto'];
    btcAddress = json["btcAddress"];
    userName = json['userName'];
    userID = json['userID'];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "userPhoto": userPhoto,
      "btcAddress": btcAddress,
      "userName": userName,
      "userID": userID,
    };
  }
}
