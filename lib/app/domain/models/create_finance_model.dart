class CreateFinanceModel {
  String? description;
  double value;
  double? tax;
  String? categoryUuid;
  DateTime date;
  DateTime? startDate;
  DateTime? endDate;
  int? installmentNumber;
  String? fatherUuid;

  CreateFinanceModel({
    this.description,
    required this.value,
    this.tax,
    this.categoryUuid,
    required this.date,
    this.startDate,
    this.endDate,
    this.installmentNumber = 1,
    this.fatherUuid,
  });

  factory CreateFinanceModel.fromMap(Map<String, dynamic> json) {
    return CreateFinanceModel(
      description: json['description'],
      value: json['value'],
      tax: json['tax'],
      categoryUuid: json['categoryUuid'],
      date: DateTime.parse(json['date']),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      installmentNumber: json['installmentNumber'],
      fatherUuid: json['fatherUuid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'value': value,
      'tax': tax,
      'categoryUuid': categoryUuid,
      'date': date.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'installmentNumber': installmentNumber,
      'fatherUuid': fatherUuid,
    };
  }
}
