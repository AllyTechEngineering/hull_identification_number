part of 'hin_data_cubit.dart';

class HinDataState extends Equatable {
  final String userHinDataInput;
  final List<HinDataModel> hinDataResponse;
  const HinDataState({
    this.userHinDataInput = '',
    required this.hinDataResponse,
  });
  factory HinDataState.initial() {
    return const HinDataState(hinDataResponse: []);
  }
  @override
  List<Object> get props => [userHinDataInput, hinDataResponse];

  @override
  String toString() =>
      'HinDataState(userHinDataInput: $userHinDataInput, hinDataResponse: $hinDataResponse)';



  HinDataState copyWith({
    String? userHinDataInput,
    List<HinDataModel>? hinDataResponse,
  }) {
    return HinDataState(
      userHinDataInput: userHinDataInput ?? this.userHinDataInput,
      hinDataResponse: hinDataResponse ?? this.hinDataResponse,
    );
  }
}
