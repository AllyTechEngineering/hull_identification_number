part of 'data_cubit.dart';

enum DataStatus {
  initial,
  loading,
  loaded,
  error,
}

class DataState extends Equatable {
  final DataStatus status;
  final HinDataModel hinData;
  final MicDataModel micDataModel;
  final CustomError error;
  const DataState({
    required this.status,
    required this.hinData,
    required this.micDataModel,
    required this.error,
  });

  factory DataState.initial() {
    return DataState(
        status: DataStatus.initial,
        hinData: HinDataModel.initial(),
        error: const CustomError(),
        micDataModel: const MicDataModel());
  }

  @override
  List<Object> get props => [status, hinData, micDataModel, error];

  @override
  String toString() =>
      'DataState(status: $status, hinData: $hinData, micDataModel: $micDataModel, error: $error)';

  DataState copyWith({
    DataStatus? status,
    HinDataModel? hinData,
    MicDataModel? micDataModel,
    CustomError? error,
  }) {
    return DataState(
      status: status ?? this.status,
      hinData: hinData ?? this.hinData,
      micDataModel: micDataModel ?? this.micDataModel,
      error: error ?? this.error,
    );
  }
}
