class PaidUserIDs {
  late List<String> paid;
  late String docID;

  PaidUserIDs({required this.paid, required this.docID});

  PaidUserIDs.fromJson(Map<String, dynamic> json) {
    paid = json['paid'].cast<String>();
    docID = json['\$id'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paid'] = paid;
    return data;
  }
}