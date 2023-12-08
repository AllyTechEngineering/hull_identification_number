import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

import '../../models/hin_data_model.dart';
import '../../utilities/decode_hin_class.dart';
part 'hin_data_state.dart';

class HinDataCubit extends Cubit<HinDataState> {
  DecodeHinClass decodeHinClass = DecodeHinClass();
  HinDataModel hinDataModel = const HinDataModel();
  HinDataCubit() : super(HinDataState.initial()) {
    userHinInputDecode('');
  }
  void userHinInputDecode(String userInputHin) {
    if (userInputHin.isEmpty) {
      userInputHin = '';
      var decodedHin = dummyHinData();
      emit(
        state.copyWith(hinDataResponse: decodedHin),
      );
    } else if (userInputHin.isNotEmpty && userInputHin.length == 12) {
      var decodedHin = decodeHIN(userInputHin);
      // debugPrint('Decoded HIN in HinDataCubit: $decodedHin');
      emit(
        state.copyWith(hinDataResponse: decodedHin),
      );
    }
  }

  List<HinDataModel> dummyHinData() {
    List<HinDataModel> tempResults = [];
    HinDataModel hinDataModel = const HinDataModel(
      manufIdentCode: '',
      hullSerialNumber: '',
      monthOfProduction: '',
      modelYear: '',
      yearOfProduction: '',
    );
    tempResults.add(hinDataModel);
    return tempResults;
  }

  List<HinDataModel> decodeHIN(String userInputHin) {
    String hin = userInputHin; // raw user HIN input with no error checks
    // debugPrint('in decodeHIN at String hin = userInputHin: $hin');
    String mic = '';
    String earlyHinWithM = '';
    String serialNumber = '';

    int currentYearValue = 0;
    List<HinDataModel> micUserDataResult = [];

    return micUserDataResult =
        validateHin(userInputHin); // new code to check for the three valid patterns
  } //List

  List<HinDataModel> validateHin(String userInputHin) {
    String hin = userInputHin;
    List<HinDataModel> validatedUserHinResults = [];
    RegExp straightYearHinFormatRegExp = RegExp(r'^\w{1}[A-Za-z]{2}\w{5}\d{2}\d{2}$');
    bool straightYearHinFormatResult = straightYearHinFormatRegExp.hasMatch(userInputHin);
    String straightYearMicResults;
    String straightYearSerialNumberResults;
    String straightYearMonthResults;
    String straightYearYearResults;
    RegExp modelYearHinFormatRegExp = RegExp(r'^\w{1}[A-Za-z]{2}\w{5}[M-m]{1}\d{2}[A-La-l]{1}$');
    bool modelYearHinFormatResult = modelYearHinFormatRegExp.hasMatch(userInputHin);
    String modelYearMicResults;
    String modelYearSerialNumberResults;
    String modelYearYearResults;
    String modelYearMonthResults;
    RegExp currentHinFormatRegExp = RegExp(r'^\w{1}[A-Za-z]{2}\w{5}[A-La-l]{1}\d{1}\d{2}$');
    bool currentHinYearFormatResult = currentHinFormatRegExp.hasMatch(userInputHin);
    DateTime now = DateTime.now();
    int currentYear = now.year;
    currentYear = currentYear - 2000;
    String currentHinYearFormatModelYearForCheckString;
    int currentHinYearFormatModelYearForCheckInt;
    String currentHinMicResults;
    String currentHinSerialNumberResults;
    String currentHinModelYearResults;
    String currentHinProductionYearResults;
    String currentHinProductionMonthResults;
    if (straightYearHinFormatResult) {
      // debugPrint(
      //     'HinDataCubit: checkUserInputHinValidator Straight Year: $straightYearHinFormatResult and HIN: $userInputHin');
      straightYearMicResults = hin.substring(0, 3);
      straightYearSerialNumberResults = hin.substring(3, 8);
      straightYearMonthResults = decodeHinClass.decodeStraightYearFormat(hin.substring(8, 10));
      straightYearYearResults = hin.substring(10, 12);
      // debugPrint(
      //     'Straight Year Format MIC: $straightYearMicResults\nSerial Number: $straightYearSerialNumberResults\nMonth:$straightYearMonthResults\nYear:  $straightYearYearResults');
      return validatedUserHinResults = straightYearFormatBuildDataModel_1972_1984(
          straightYearMicResults,
          straightYearSerialNumberResults,
          straightYearMonthResults,
          straightYearYearResults);
    }

    if (modelYearHinFormatResult) {
      // debugPrint(
      //     'HinDataCubit: modelYearFormatResult test using RegExp: $modelYearHinFormatResult');
      modelYearMicResults = hin.substring(0, 3);
      modelYearSerialNumberResults = hin.substring(3, 8);
      modelYearYearResults = hin.substring(9, 11);
      modelYearMonthResults = decodeHinClass.decodeMonthModelYearFormat(hin.substring(11));
      debugPrint(
          'Model Year Format MIC: $modelYearMicResults\nSerial Number: $modelYearSerialNumberResults\nProduction Month: $modelYearMonthResults\nProduction Year: $modelYearYearResults');
      return validatedUserHinResults = modelYearFormatBuildDataModel_1972_1984(modelYearMicResults,
          modelYearSerialNumberResults, modelYearYearResults, modelYearMonthResults);
    }
    try {
      if (currentHinYearFormatResult) {
        // Start: Code to deal with 1980, 1990 and 2000 plus
        currentHinYearFormatModelYearForCheckString = hin.substring(10, 12);
        currentHinYearFormatModelYearForCheckInt =
            int.parse(currentHinYearFormatModelYearForCheckString);
        debugPrint(
            'First currentHinYearFormatModelYearForCheckInt: $currentHinYearFormatModelYearForCheckInt');
        // Current Hin for 1984 to 1989
        if (currentHinYearFormatModelYearForCheckInt >= 84 &&
            currentHinYearFormatModelYearForCheckInt <= 89) {
          currentHinMicResults = hin.substring(0, 3);
          currentHinSerialNumberResults = hin.substring(3, 8);
          currentHinModelYearResults = '19${hin.substring(10, 12)}';
          currentHinProductionYearResults = '198${hin.substring(9, 10)}';
          currentHinProductionMonthResults =
              decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));

          return validatedUserHinResults = hinCurrentFormatBuildDataModel(
            currentHinMicResults,
            currentHinSerialNumberResults,
            currentHinProductionMonthResults,
            currentHinProductionYearResults,
            currentHinModelYearResults,
          );
        } else if (currentHinYearFormatModelYearForCheckInt >= 90 &&
            currentHinYearFormatModelYearForCheckInt <= 99) {
          currentHinMicResults = hin.substring(0, 3);
          currentHinSerialNumberResults = hin.substring(3, 8);
          currentHinModelYearResults = '19${hin.substring(10, 12)}';
          currentHinProductionYearResults = '199${hin.substring(9, 10)}';
          String currentHinProductionMonthResults =
              decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
          return validatedUserHinResults = hinCurrentFormatBuildDataModel(
            currentHinMicResults,
            currentHinSerialNumberResults,
            currentHinProductionMonthResults,
            currentHinProductionYearResults,
            currentHinModelYearResults,
          );
        } else if (currentHinYearFormatModelYearForCheckInt >= 0 &&
            currentHinYearFormatModelYearForCheckInt <= 9) {
          currentHinMicResults = hin.substring(0, 3);
          currentHinSerialNumberResults = hin.substring(3, 8);
          currentHinModelYearResults = '20${hin.substring(10, 12)}';
          currentHinProductionYearResults = '200${hin.substring(9, 10)}';
          String currentHinProductionMonthResults =
              decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
          return validatedUserHinResults = hinCurrentFormatBuildDataModel(
            currentHinMicResults,
            currentHinSerialNumberResults,
            currentHinProductionMonthResults,
            currentHinProductionYearResults,
            currentHinModelYearResults,
          );
        } else if (currentHinYearFormatModelYearForCheckInt >= 10 &&
            currentHinYearFormatModelYearForCheckInt <= 19) {
          currentHinMicResults = hin.substring(0, 3);
          currentHinSerialNumberResults = hin.substring(3, 8);
          currentHinModelYearResults = '20${hin.substring(10, 12)}';
          currentHinProductionYearResults = '201${hin.substring(9, 10)}';
          String currentHinProductionMonthResults =
              decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
          return validatedUserHinResults = hinCurrentFormatBuildDataModel(
            currentHinMicResults,
            currentHinSerialNumberResults,
            currentHinProductionMonthResults,
            currentHinProductionYearResults,
            currentHinModelYearResults,
          );
        } else if (currentHinYearFormatModelYearForCheckInt >= 20 &&
            currentHinYearFormatModelYearForCheckInt <= 29) {
          currentHinMicResults = hin.substring(0, 3);
          currentHinSerialNumberResults = hin.substring(3, 8);
          currentHinModelYearResults = '20${hin.substring(10, 12)}';
          currentHinProductionYearResults = '202${hin.substring(9, 10)}';
          String currentHinProductionMonthResults =
              decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
          return validatedUserHinResults = hinCurrentFormatBuildDataModel(
            currentHinMicResults,
            currentHinSerialNumberResults,
            currentHinProductionMonthResults,
            currentHinProductionYearResults,
            currentHinModelYearResults,
          );
        } else if (currentHinYearFormatModelYearForCheckInt >= 30 &&
            currentHinYearFormatModelYearForCheckInt <= 39) {
          currentHinMicResults = hin.substring(0, 3);
          currentHinSerialNumberResults = hin.substring(3, 8);
          currentHinModelYearResults = '20${hin.substring(10, 12)}';
          currentHinProductionYearResults = '203${hin.substring(9, 10)}';
          String currentHinProductionMonthResults =
              decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
          return validatedUserHinResults = hinCurrentFormatBuildDataModel(
            currentHinMicResults,
            currentHinSerialNumberResults,
            currentHinProductionMonthResults,
            currentHinProductionYearResults,
            currentHinModelYearResults,
          );
        }
      } //if (currentHinYearFormatResult)
    } catch (e) {
      debugPrint('Current Hin Try Catch error: $e');
    }
    if (currentHinYearFormatResult) {
      // Start: Code to deal with 1980, 1990 and 2000 plus
      currentHinYearFormatModelYearForCheckString = hin.substring(10, 12);
      currentHinYearFormatModelYearForCheckInt =
          int.parse(currentHinYearFormatModelYearForCheckString);
      debugPrint(
          'First currentHinYearFormatModelYearForCheckInt: $currentHinYearFormatModelYearForCheckInt');
      // Current Hin for 1984 to 1989
      if (currentHinYearFormatModelYearForCheckInt >= 84 &&
          currentHinYearFormatModelYearForCheckInt <= 89) {
        currentHinMicResults = hin.substring(0, 3);
        currentHinSerialNumberResults = hin.substring(3, 8);
        currentHinModelYearResults = '19${hin.substring(10, 12)}';
        currentHinProductionYearResults = '198${hin.substring(9, 10)}';
        currentHinProductionMonthResults =
            decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
        // debugPrint(
        //     'Current HIN Format MIC: $currentHinMicResults\nSerial Number: $currentHinSerialNumberResults\nModel Year: $currentHinModelYearResults\n Production Year: $currentHinProductionYearResults\n Production Month: $currentHinProductionMonthResults');
        debugPrint(
            'End of 84 to 89 if currentHinYearFormatModelYearForCheckInt: $currentHinYearFormatModelYearForCheckInt');
        return validatedUserHinResults = hinCurrentFormatBuildDataModel(
          currentHinMicResults,
          currentHinSerialNumberResults,
          currentHinProductionMonthResults,
          currentHinProductionYearResults,
          currentHinModelYearResults,
        );
      } else if (currentHinYearFormatModelYearForCheckInt >= 90 &&
          currentHinYearFormatModelYearForCheckInt <= 99) {
        currentHinMicResults = hin.substring(0, 3);
        currentHinSerialNumberResults = hin.substring(3, 8);
        currentHinModelYearResults = '19${hin.substring(10, 12)}';
        currentHinProductionYearResults = '199${hin.substring(9, 10)}';
        String currentHinProductionMonthResults =
            decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
        return validatedUserHinResults = hinCurrentFormatBuildDataModel(
          currentHinMicResults,
          currentHinSerialNumberResults,
          currentHinProductionMonthResults,
          currentHinProductionYearResults,
          currentHinModelYearResults,
        );
      } else if (currentHinYearFormatModelYearForCheckInt >= 0 &&
          currentHinYearFormatModelYearForCheckInt <= 9) {
        currentHinMicResults = hin.substring(0, 3);
        currentHinSerialNumberResults = hin.substring(3, 8);
        currentHinModelYearResults = '20${hin.substring(10, 12)}';
        currentHinProductionYearResults = '200${hin.substring(9, 10)}';
        String currentHinProductionMonthResults =
            decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
        return validatedUserHinResults = hinCurrentFormatBuildDataModel(
          currentHinMicResults,
          currentHinSerialNumberResults,
          currentHinProductionMonthResults,
          currentHinProductionYearResults,
          currentHinModelYearResults,
        );
      } else if (currentHinYearFormatModelYearForCheckInt >= 10 &&
          currentHinYearFormatModelYearForCheckInt <= 19) {
        currentHinMicResults = hin.substring(0, 3);
        currentHinSerialNumberResults = hin.substring(3, 8);
        currentHinModelYearResults = '20${hin.substring(10, 12)}';
        currentHinProductionYearResults = '201${hin.substring(9, 10)}';
        String currentHinProductionMonthResults =
            decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
        return validatedUserHinResults = hinCurrentFormatBuildDataModel(
          currentHinMicResults,
          currentHinSerialNumberResults,
          currentHinProductionMonthResults,
          currentHinProductionYearResults,
          currentHinModelYearResults,
        );
      } else if (currentHinYearFormatModelYearForCheckInt >= 20 &&
          currentHinYearFormatModelYearForCheckInt <= 29) {
        currentHinMicResults = hin.substring(0, 3);
        currentHinSerialNumberResults = hin.substring(3, 8);
        currentHinModelYearResults = '20${hin.substring(10, 12)}';
        currentHinProductionYearResults = '202${hin.substring(9, 10)}';
        String currentHinProductionMonthResults =
            decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
        return validatedUserHinResults = hinCurrentFormatBuildDataModel(
          currentHinMicResults,
          currentHinSerialNumberResults,
          currentHinProductionMonthResults,
          currentHinProductionYearResults,
          currentHinModelYearResults,
        );
      } else if (currentHinYearFormatModelYearForCheckInt >= 30 &&
          currentHinYearFormatModelYearForCheckInt <= 39) {
        currentHinMicResults = hin.substring(0, 3);
        currentHinSerialNumberResults = hin.substring(3, 8);
        currentHinModelYearResults = '20${hin.substring(10, 12)}';
        currentHinProductionYearResults = '203${hin.substring(9, 10)}';
        String currentHinProductionMonthResults =
            decodeHinClass.decodeMonthCurrentFormat(hin.substring(8, 9));
        return validatedUserHinResults = hinCurrentFormatBuildDataModel(
          currentHinMicResults,
          currentHinSerialNumberResults,
          currentHinProductionMonthResults,
          currentHinProductionYearResults,
          currentHinModelYearResults,
        );
      }
    } //if (currentHinYearFormatResult)

    if (!currentHinYearFormatResult && !modelYearHinFormatResult && !straightYearHinFormatResult) {
      debugPrint('In the if that checks to see if the HIN does not fit any of the patterns: $hin');
      // return empty strings
      return validatedUserHinResults = hinCurrentFormatBuildDataModel(
        '',
        '',
        '',
        '',
        '',
      );
    }
    return validatedUserHinResults;
  } //validate

  List<HinDataModel> modelYearFormatBuildDataModel_1972_1984(String mic, String serialNumber,
      String modelYearFormatYear, String modelYearFormatMonthOfProd) {
    List<HinDataModel> tempResults = [];
    // manufIdentCode: '',
    // hullSerialNumber: '',
    // monthOfProduction: '',
    // yearOfProduction: '',
    // modelYear: '');
    HinDataModel hinDataModel = HinDataModel(
      manufIdentCode: mic,
      hullSerialNumber: serialNumber,
      monthOfProduction: modelYearFormatMonthOfProd,
      yearOfProduction: 'N/A',
      modelYear: '19$modelYearFormatYear',
    );
    // tempResults.add(hinDataModel);
    // debugPrint('In himWithMyearResults: $tempResults');
    tempResults.add(hinDataModel);
    return tempResults;
  } // himWithMyearResults

  List<HinDataModel> straightYearFormatBuildDataModel_1972_1984(
    String mic,
    String serialNumber,
    String straightYearFormatProdMonth,
    String straightYearFormatProdYear,
  ) {
    List<HinDataModel> tempResults = [];
    // manufIdentCode: '',
    // hullSerialNumber: '',
    // monthOfProduction: '',
    // yearOfProduction: '',
    // modelYear: '');
    HinDataModel hinDataModel = HinDataModel(
      manufIdentCode: mic,
      hullSerialNumber: serialNumber,
      monthOfProduction: straightYearFormatProdMonth,
      yearOfProduction: '19$straightYearFormatProdYear',
      modelYear: 'N/A',
    );
    tempResults.add(hinDataModel);
    // debugPrint('In himWithMyearResults: $tempResults');
    tempResults.add(hinDataModel);
    return tempResults;
  }

  List<HinDataModel> hinCurrentFormatBuildDataModel(
    String mic,
    String serialNumber,
    String currentHinProdMonth,
    String currentHinProdYear,
    String currentHinModelYear,
  ) {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    currentYear = currentYear - 2000;

    List<HinDataModel> tempResults = [];
    HinDataModel hinDataModel = HinDataModel(
      manufIdentCode: mic,
      hullSerialNumber: serialNumber,
      monthOfProduction: currentHinProdMonth,
      modelYear: currentHinModelYear,
      yearOfProduction: currentHinProdYear,
    );
    tempResults.add(hinDataModel);
    // debugPrint('In himWithMyearResults: $tempResults');
    tempResults.add(hinDataModel);
    return tempResults;
  }

  List<HinDataModel> hinCurrentFormatYear2000(String mic, String currentHinProdYear,
      String currentHinModelYear, String currentHinProdMonth, String serialNumber) {
    List<HinDataModel> tempResults = [];
    HinDataModel hinDataModel = HinDataModel(
      manufIdentCode: mic,
      hullSerialNumber: serialNumber,
      monthOfProduction: currentHinProdMonth,
      modelYear: '20$currentHinModelYear',
      yearOfProduction: '20$currentHinProdYear',
    );
    tempResults.add(hinDataModel);
    // debugPrint('In himWithMyearResults: $tempResults');
    tempResults.add(hinDataModel);
    return tempResults;
  }

  List<HinDataModel> hinCurrentFormatYear1984_1999(String mic, String currentHinProdYear,
      String currentHinModelYear, String currentHinProdMonth, String serialNumber) {
    List<HinDataModel> tempResults = [];
    HinDataModel hinDataModel = HinDataModel(
      manufIdentCode: mic,
      hullSerialNumber: serialNumber,
      monthOfProduction: currentHinProdMonth,
      modelYear: '19$currentHinModelYear',
      yearOfProduction: '19$currentHinProdYear',
    );
    tempResults.add(hinDataModel);
    // debugPrint('In himWithMyearResults: $tempResults');
    tempResults.add(hinDataModel);
    return tempResults;
  }

  void hinLengthError() {
    debugPrint('hinLengthError');
  }

  void hinMicError() {
    debugPrint('hinMicError');
  }

  void hinWithMyearError() {
    debugPrint('hinWithMyearError');
  }

  void hinFormatError() {
    debugPrint('hinFormatError');
  }
}
