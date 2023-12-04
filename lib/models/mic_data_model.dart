import 'package:equatable/equatable.dart';

class MicDataModel extends Equatable {
  final String mic;
  final String company;
  final String address;
  final String city;
  final String state;

  const MicDataModel({
    this.mic = '',
    this.company = '',
    this.address = '',
    this.city = '',
    this.state = '',
  });

  @override
  List<Object> get props {
    return [
      mic,
      company,
      address,
      city,
      state,
    ];
  }

  factory MicDataModel.initial() => const MicDataModel(
        mic: '',
        company: '',
        address: '',
        city: '',
        state: '',
      );

  @override
  String toString() {
    return 'MicDataModel(mic: $mic, company: $company, address: $address, city: $city, state: $state)';
  }
}
