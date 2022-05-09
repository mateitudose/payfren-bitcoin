class Payment {
  late String? userID;
  late String paidTo;
  late String amount;
  late String date;

  Payment({this.userID ,required this.paidTo, required this.amount, required this.date});

  Payment.fromJson(Map<String, dynamic> json) {
    paidTo = json['paidTo'];
    amount = json['amount'];
    date = json['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "paidTo": paidTo,
      "amount": amount,
      "date": date,
    };
  }
}
