part of 'data_cubit.dart';

abstract class DataState extends Equatable {}

class InitialState extends DataState {
  @override
  List<Object> get props => [];
}

class LoadingState extends DataState {
  @override
  List<Object> get props => [];
}

class LoadedState extends DataState {
  LoadedState(this.micData);

  final List<MicDataModel> micData;

  @override
  List<Object> get props => [micData];

  @override
  String toString() {
    return 'LoadedState(centerboard: $micData)';
  }
}

class ErrorState extends DataState {
  @override
  List<Object> get props => [];
}
