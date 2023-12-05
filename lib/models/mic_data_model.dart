import 'package:equatable/equatable.dart';

class MicDataModel extends Equatable {
  final String company;
  final String address;
  final String city;
  final String state;

  const MicDataModel({
    this.company = '',
    this.address = '',
    this.city = '',
    this.state = '',
  });

  @override
  List<Object> get props {
    return [
      company,
      address,
      city,
      state,
    ];
  }

  factory MicDataModel.initial() => const MicDataModel(
        company: '',
        address: '',
        city: '',
        state: '',
      );

  @override
  String toString() {
    return 'MicDataModel(company: $company, address: $address, city: $city, state: $state)';
  }
}
