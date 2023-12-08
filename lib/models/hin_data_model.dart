import 'package:equatable/equatable.dart';

class HinDataModel extends Equatable {
  final String manufIdentCode;
  final String hullSerialNumber;
  final String monthOfProduction;
  final String yearOfProduction;
  final String modelYear;
  const HinDataModel({
    this.manufIdentCode = '',
    this.hullSerialNumber = '',
    this.monthOfProduction = '',
    this.yearOfProduction = '',
    this.modelYear = '',
  });

  factory HinDataModel.initial() => const HinDataModel(
      manufIdentCode: '',
      hullSerialNumber: '',
      monthOfProduction: '',
      yearOfProduction: '',
      modelYear: '');

  @override
  List<Object> get props {
    return [
      manufIdentCode,
      hullSerialNumber,
      monthOfProduction,
      yearOfProduction,
      modelYear,
    ];
  }

  @override
  String toString() {
    return 'HinDataModel(manufIdentCode: $manufIdentCode, hullSerialNumber: $hullSerialNumber, monthOfProduction: $monthOfProduction, yearOfProduction: $yearOfProduction, modelYear: $modelYear)';
  }

  HinDataModel copyWith({
    String? manufIdentCode,
    String? hullSerialNumber,
    String? monthOfProduction,
    String? yearOfProduction,
    String? modelYear,
  }) {
    return HinDataModel(
      manufIdentCode: manufIdentCode ?? this.manufIdentCode,
      hullSerialNumber: hullSerialNumber ?? this.hullSerialNumber,
      monthOfProduction: monthOfProduction ?? this.monthOfProduction,
      yearOfProduction: yearOfProduction ?? this.yearOfProduction,
      modelYear: modelYear ?? this.modelYear,
    );
  }
}
