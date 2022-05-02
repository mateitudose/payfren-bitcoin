class PaidUserIDs {
  late List<String> paid;

  PaidUserIDs({required this.paid});

  PaidUserIDs.fromJson(Map<String, dynamic> json) {
    paid = json['paid'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paid'] = paid;
    return data;
  }
}