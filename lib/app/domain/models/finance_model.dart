import 'dart:math';

import 'package:gestor_financeiro/app/domain/models/category_model.dart';

class FinanceModel {
  String uuid;
  String? description;
  double value;
  double? tax;
  String? categoryUuid;
  CategoryModel? category;
  DateTime date;
  DateTime? startDate;
  DateTime? endDate;
  int? installmentNumber;
  DateTime createdAt;
  DateTime? updatedAt;
  String? fatherUuid;
  FinanceModel? financeFather;

  FinanceModel({
    required this.uuid,
    this.description,
    required this.value,
    this.tax,
    this.categoryUuid,
    this.category,
    required this.date,
    this.startDate,
    this.endDate,
    required this.createdAt,
    this.installmentNumber,
    this.updatedAt,
    this.fatherUuid,
    this.financeFather,
  });

  factory FinanceModel.fromMap(Map<String, dynamic> json) {
    return FinanceModel(
      uuid: json['uuid'],
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
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      fatherUuid: json['fatherUuid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'description': description,
      'value': value,
      'tax': tax,
      'categoryUuid': categoryUuid,
      'date': date.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'installmentNumber': installmentNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'fatherUuid': fatherUuid,
    };
  }

  FinanceModel copyWith({
    String? uuid,
    String? description,
    double? value,
    double? tax,
    String? categoryUuid,
    CategoryModel? category,
    DateTime? date,
    DateTime? startDate,
    DateTime? endDate,
    int? installmentNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fatherUuid,
  }) {
    return FinanceModel(
      uuid: uuid ?? this.uuid,
      description: description ?? this.description,
      value: value ?? this.value,
      tax: tax ?? this.tax,
      categoryUuid: categoryUuid ?? this.categoryUuid,
      category: category ?? this.category,
      date: date ?? this.date,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      installmentNumber: installmentNumber ?? this.installmentNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fatherUuid: fatherUuid ?? this.fatherUuid,
    );
  }

  List<double> calcularAntecipacaoListFather() {
    if (startDate == null || endDate == null || tax == null) {
      return [];
    }
    final int baseDias = 30;
    final hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final taxaMensal = tax! / 100.0;
    final taxaDiaria = pow(1 + taxaMensal, 1 / baseDias).toDouble() - 1;

    final qtdMeses =
        (endDate!.year - startDate!.year) * 12 +
        (endDate!.month - startDate!.month);

    final parcelas = <double>[];

    for (int t = 1; t <= qtdMeses; t++) {
      final vencimento = DateTime(
        startDate!.year,
        startDate!.month + t,
        startDate!.day,
      );

      final dias = vencimento.difference(hoje).inDays;
      if (dias <= 0) continue;

      final vp = value / pow(1 + taxaDiaria, dias);
      parcelas.add(vp.toDouble());
    }

    return parcelas;
  }

  double calcularAntecipacaoTotal() {
    if (startDate == null || endDate == null || tax == null) {
      return 0;
    }
    final int baseDias = 30;
    final hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final taxaMensal = tax! / 100.0;
    final taxaDiaria = pow(1 + taxaMensal, 1 / baseDias).toDouble() - 1;

    final qtdMeses =
        (endDate!.year - startDate!.year) * 12 +
        (endDate!.month - startDate!.month);

    final parcelas = <double>[];

    for (int t = 1; t <= qtdMeses; t++) {
      final vencimento = DateTime(
        startDate!.year,
        startDate!.month + t,
        startDate!.day,
      );

      final dias = vencimento.difference(hoje).inDays;
      if (dias <= 0) continue;

      final vp = value / pow(1 + taxaDiaria, dias);
      parcelas.add(vp.toDouble());
    }

    return parcelas.fold(0.0, (value, element) => value + element);
  }

  double calcularAntecipacaoParcela({DateTime? referencia}) {
    if (startDate == null || endDate == null || tax == null) {
      return 0;
    }
    final int baseDias = 30;
    final hoje = DateTime(
      referencia?.year ?? DateTime.now().year,
      referencia?.month ?? DateTime.now().month,
      referencia?.day ?? DateTime.now().day,
    );

    final taxaMensal = tax! / 100.0;
    final taxaDiaria = pow(1 + taxaMensal, 1 / baseDias).toDouble() - 1;

    final qtdMeses =
        (date.year - startDate!.year) * 12 + (date.month - startDate!.month);

    final vencimento = DateTime(
      startDate!.year,
      startDate!.month + qtdMeses,
      startDate!.day,
    );
    final dias = vencimento.difference(hoje).inDays;
    if (dias <= 0) return value;
    final vp = value / pow(1 + taxaDiaria, dias);

    return vp;
  }
}
