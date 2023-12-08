import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:hull_identification_number/models/mic_data_model.dart';
import 'package:hull_identification_number/repositories/mic_repository.dart';

part 'mic_data_state.dart';

class MicDataCubit extends Cubit<MicDataState> {
  final MicRepository repository;

  MicDataCubit({required this.repository}) : super(InitialState()) {
    getUserEnteredMicData('111');
  }
  void getUserEnteredMicData(String userEnteredHinMic) async {
    List<MicDataModel>;
    debugPrint(' in getUserEnteredMicData and getUserEnteredMicData is: $userEnteredHinMic');
    String validMicFromSubString;
    if (userEnteredHinMic.length > 2) {
      validMicFromSubString = userEnteredHinMic.substring(0, 3);
      debugPrint(
          'in if (userEnteredHinMic.length >2) and validMicFromSubString = userEnteredHinMic.substring(0, 3): $validMicFromSubString ');
    }
    RegExp validateUserEnteredMicDataFromHin = RegExp(r'^\w[A-Za-z]{2}$');
    debugPrint(
        'Testing RegExp validateUserEnteredMicDataFromHin RegExp: $validateUserEnteredMicDataFromHin');
    bool validMicFromHinResult =
        validateUserEnteredMicDataFromHin.hasMatch(userEnteredHinMic.substring(0, 3));
    debugPrint('Testing the bool validMicFromHinResult: $validMicFromHinResult ');
    if (validMicFromHinResult) {
      debugPrint(
          'In the if after checking using RegExp for validMicFromHinResult: $validMicFromHinResult');
      try {
        emit(
          LoadingState(),
        );
        final userEnteredMicDataList =
            await repository.getMicData(userEnteredHinMic.substring(0, 3));
        emit(LoadedState(userEnteredMicDataList));
      } catch (e) {
        // debugPrint('in MicDataCubit and this is the error: $e');
        emit(ErrorState());
      }
    } else if (validMicFromHinResult == false) {
      debugPrint('In else if (validMicFromHinResult == false) ');
      try {
        emit(
          LoadingState(),
        );
        final userEnteredMicDataList = await repository.getMicData('111');
        emit(LoadedState(userEnteredMicDataList));
      } catch (e) {
        // debugPrint('in MicDataCubit and this is the error: $e');
        emit(ErrorState());
      }
    }
  }
}
