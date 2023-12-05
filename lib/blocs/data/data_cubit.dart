import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hull_identification_number/models/mic_data_model.dart';
import 'package:hull_identification_number/repositories/mic_repository.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  final MicRepository repository;

  DataCubit({required this.repository}) : super(InitialState()) {
    getUserEnteredMicData('111');
  }
  void getUserEnteredMicData(String userEnteredHinMic) async {
    List<MicDataModel>;
    try {
      emit(
        LoadingState(),
      );
      final userEnteredMicDataList = await repository.getMicData(userEnteredHinMic);
      emit(LoadedState(userEnteredMicDataList));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
