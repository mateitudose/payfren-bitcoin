class Payment {
  late String paidTo;
  late double amount;
  late String date;

  Payment({required this.paidTo, required this.amount, required this.date});

  Payment.fromJson(Map<String, dynamic> json) {
    paidTo = json['paidTo'];
    amount = json['amount'];
    date = json['date'];
  }
}
