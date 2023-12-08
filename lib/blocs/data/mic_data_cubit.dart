import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

import '../../models/mic_data_model.dart';
import '../../repositories/mic_repository.dart';

part 'mic_data_state.dart';

class MicDataCubit extends Cubit<MicDataState> {
  final MicRepository repository;

  MicDataCubit({required this.repository}) : super(InitialState()) {
    getUserEnteredMicData('111');
  }
  void getUserEnteredMicData(String userEnteredHinMic) async {
    List<MicDataModel>;
    // debugPrint(' in getUserEnteredMicData and getUserEnteredMicData is: $userEnteredHinMic');
    String validMicFromSubString;
    if (userEnteredHinMic.length > 2) {
      validMicFromSubString = userEnteredHinMic.substring(0, 3);
      // debugPrint(
      //     'in if (userEnteredHinMic.length >2) and validMicFromSubString = userEnteredHinMic.substring(0, 3): $validMicFromSubString ');
    }
    RegExp validateUserEnteredMicDataFromHin = RegExp(r'^\w[A-Za-z]{2}$');
    // debugPrint(
    //     'Testing RegExp validateUserEnteredMicDataFromHin RegExp: $validateUserEnteredMicDataFromHin');
    bool validMicFromHinResult =
        validateUserEnteredMicDataFromHin.hasMatch(userEnteredHinMic.substring(0, 3));
    // debugPrint('Testing the bool validMicFromHinResult: $validMicFromHinResult ');
    if (validMicFromHinResult) {
      // debugPrint(
      //     'In the if after checking using RegExp for validMicFromHinResult: $validMicFromHinResult');
      try {
        emit(
          LoadingState(),
        );
        final userInputValidatedMic = validateUserInputHinAndMic(userEnteredHinMic);
        final validatedMic = await repository.getMicData(userInputValidatedMic);
        emit(LoadedState(validatedMic));
      } catch (e) {
        // debugPrint('in MicDataCubit and this is the error: $e');
        emit(ErrorState());
      }
    } else if (validMicFromHinResult == false) {
      // debugPrint('In else if (validMicFromHinResult == false) ');
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
    } //else If
  } //getUserEnteredMicData

  String validateUserInputHinAndMic(String userInputHin) {
    String hin = userInputHin;
    RegExp straightYearHinFormatRegExp = RegExp(r'^\w{1}[A-Za-z]{2}\w{5}\d{2}\d{2}$');
    bool straightYearHinFormatResult = straightYearHinFormatRegExp.hasMatch(userInputHin);
    String straightYearMicResults;

    RegExp modelYearHinFormatRegExp = RegExp(r'^\w{1}[A-Za-z]{2}\w{5}[M-m]{1}\d{2}[A-La-l]{1}$');
    bool modelYearHinFormatResult = modelYearHinFormatRegExp.hasMatch(userInputHin);
    String modelYearMicResults;

    RegExp currentHinFormatRegExp = RegExp(r'^\w{1}[A-Za-z]{2}\w{5}[A-La-l]{1}\d{1}\d{2}$');
    bool currentHinYearFormatResult = currentHinFormatRegExp.hasMatch(userInputHin);
    String currentHinMicResults;
    if (straightYearHinFormatResult) {
      straightYearMicResults = hin.substring(0, 3);
      debugPrint(
          'in straightYearHinFormatResult: $straightYearHinFormatResult\nMIC: $straightYearMicResults');
      return straightYearMicResults;
    }
    if (modelYearHinFormatResult) {
      modelYearMicResults = hin.substring(0, 3);
      debugPrint(
          'in modelYearHinFormatRegExp: $modelYearHinFormatResult\nMIC: $modelYearMicResults');
      return modelYearMicResults;
    }
    if (currentHinYearFormatResult) {
      currentHinMicResults = hin.substring(0, 3);
      debugPrint(
          'in currentHinYearFormatResult: $currentHinYearFormatResult\n MIC: $currentHinMicResults');
      return currentHinMicResults;
    }
    if (!straightYearHinFormatResult && !modelYearHinFormatResult && !currentHinYearFormatResult) {
      debugPrint(
          'in no patter fits: $straightYearHinFormatResult\n$modelYearHinFormatResult\n$currentHinYearFormatResult');
      return '111';
    }
    return '111';
  } //validateUserInputHinAndMic
} // class
