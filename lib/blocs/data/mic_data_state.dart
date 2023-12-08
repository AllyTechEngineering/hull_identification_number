part of 'mic_data_cubit.dart';

abstract class MicDataState extends Equatable {}

class InitialState extends MicDataState {
  @override
  List<Object> get props => [];
}

class LoadingState extends MicDataState {
  @override
  List<Object> get props => [];
}

class LoadedState extends MicDataState {
  LoadedState(this.micData);

  final List<MicDataModel> micData;

  @override
  List<Object> get props => [micData];

  @override
  String toString() {
    return 'LoadedState(centerboard: $micData)';
  }
}

class ErrorState extends MicDataState {
  @override
  List<Object> get props => [];
}
