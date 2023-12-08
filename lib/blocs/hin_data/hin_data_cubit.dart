import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hull_identification_number/models/hin_data_model.dart';
import 'package:hull_identification_number/utilities/decode_hin_class.dart';
import 'package:flutter/material.dart';
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
    String hin = userInputHin;
    // debugPrint('in decodeHIN at String hin = userInputHin: $hin');
    String mic = '';
    String earlyHinWithM = '';
    String serialNumber = '';
    validateHin(userInputHin);

    /// Three HIN Formats
    /// Straight Year Format (Used November 1, 1972– July 31, 1984)
    /// ABC 12345   08                    83
    /// MIC SN      Month of production   Year of production
    /// Model Year Format (Used November 1, 1972– July 31, 1984)
    /// XYZ 45678   M                   83               A
    /// MIC SN      Denotes model/year  production year  production month
    /// Current Format (Used exclusively August 1, 1984 to present)
    /// BMA 45678   H4                    85
    /// MIC SN      Month of production   Year of production

    // int earlyHinWithMyearToInt = 0;
    int currentYearValue = 0;
    List<HinDataModel> micUserDataResult = [];
    // debugPrint('userInputHin.length ${userInputHin.length}');
    // if (userInputHin.isEmpty || userInputHin.length < 12) {
    //   userInputHin = 'AAA11111A100';
    // }
    if (userInputHin.isNotEmpty && userInputHin.length == 12) {
      // debugPrint('inuserInputHin.isEmpty${userInputHin.isNotEmpty}');
      mic = hin.substring(0, 3);
      // Define regular expressions to check for numeric and alpha characters
      RegExp numericRegExp = RegExp(r'\d');
      RegExp alphaRegExp = RegExp(r'[a-zA-Z]');
      // Iterate through each character in the string

      for (int i = 0; i < mic.length; i++) {
        bool micHasNumericAt1 = numericRegExp.hasMatch(mic[1]);
        bool micHasNumericAt2 = numericRegExp.hasMatch(mic[2]);
        // Check if the character is alpha
        bool isAlpha = alphaRegExp.hasMatch(mic[i]);

        /// TODO: check to see if the HIN is straight year, Model year or Current
        /// HIN format: 0 1 2 3 4 5 6 7 8 9 10 11 (12 digits)
        /// *Straight year November 1972 to July 1984*
        /// 0 1 2 are alpha but 0 can be numeric for MIC
        /// 3 4 5 6 7 are alpha numeric for S/N
        /// 8 9 are numeric for month of production
        /// 10 11 are for year of production
        /// No model year!
        ///
        /// *Model year November 1972 to July 1984*
        /// 0 1 2 are alpha but 0 can be numeric for MIC
        /// 3 4 5 6 7 are alpha numeric for S/N
        /// 8 is an M always
        /// 9 10 are numeric for model year
        /// 1984 to 1999 or 2000 to current year 2023
        /// 11 is alpha for month (A - L) (same as current HIN)
        /// No production year!
        /// *Current HIN August 1984 to present*
        /// 0 1 2 are MIC and 1 2 are alpha
        /// 3 4 5 6 7 are serial number and are alpha numeric
        /// 8 is alpha for month (A - L)
        /// 9 is the production year
        /// 10 and 11 are the model year and need to be used to change the production year format
        /// 1984 to 1999 or 2000 to current year 2023
        if (micHasNumericAt1 || micHasNumericAt2) {
          hinMicError();
          // debugPrint('In micHasNumericAt1 $micUserDataResult');
          return micUserDataResult;
          // Handle the exception here, for example, show an error message to the user.
        }
        // micUserDataResult = mic;
        serialNumber = hin.substring(3, 8);
        earlyHinWithM = hin.substring(8, 9);
      }

      if (earlyHinWithM == 'M') {
        String earlyHinWithMyear = hin.substring(9, 11);
        String monthOfCert = decodeHinClass.decodeMonthModelYearFormat(hin.substring(11));
        // debugPrint('In earlyHinWithM $earlyHinWithMyear and $monthOfCert');
        return micUserDataResult =
            himWithMyearResults(mic, earlyHinWithMyear, monthOfCert, serialNumber);
      } //if early HIN Model Year M

      if (earlyHinWithM != 'M') {
        String straightYearMonthFormat = hin.substring(8, 10);
        // debugPrint('straightYearMonthFormat before call: $straightYearMonthFormat');
        String currentHinModelMonthValue =
            decodeHinClass.decodeStraightYearFormat(straightYearMonthFormat);
        // debugPrint(
        //     'In NOT earlyHinWithM $currentHinModelMonthValue and $currentHinModelMonthValue');
        String straightYearFormat = hin.substring(10, 12);
        // debugPrint('straightYearFormat: $straightYearFormat');

        String currentHinYear = hin.substring(10, 12);

        DateTime now = DateTime.now();
        int currentYear = now.year;
        currentYear = currentYear - 2000;
        if (currentHinYear != '71' && currentYearValue <= 84) {
          // debugPrint('In else if straight Model Year');
          return micUserDataResult = hinStraightYearFormat_1972_1984(
              mic, currentHinYear, currentHinModelMonthValue, serialNumber);
        } else if (currentYearValue >= 0 && currentYearValue <= currentYear) {
          // debugPrint('In if in 2000 plus year: $currentYear');
          return micUserDataResult = hinCurrentFormatYear2000(
              mic, '20$currentHinYear', currentHinModelMonthValue, serialNumber);
        } else if (currentYearValue >= 84 && currentYearValue <= 99) {
          // debugPrint('In else if in 1984 to 1999 year');
          return micUserDataResult = hinCurrentFormatYear1984_1999(
              mic, '19$currentHinYear', currentHinModelMonthValue, serialNumber);
        }
      }
    }
    return micUserDataResult;
  } //List

  void validateHin(String userInputHin) {
    // debugPrint('In checkUserInputHinValidator and HIN is: $userInputHin');
    RegExp straightYearHinFormatRegExp = RegExp(r'^\w{1}[A-Za-z]{2}\w{5}\d{2}\d{2}$');
    bool straightYearHinFormatResult = straightYearHinFormatRegExp.hasMatch(userInputHin);
    if (straightYearHinFormatResult) {
      debugPrint(
          'HinDataCubit: checkUserInputHinValidator Straight Year: $straightYearHinFormatResult and HIN: $userInputHin');
    }
    RegExp modelYearHinFormatRegExp = RegExp(r'^\w{1}[A-Za-z]{2}\w{5}[M-m]{1}\d{2}[A-La-l]{1}$');
    bool modelYearHinFormatResult = modelYearHinFormatRegExp.hasMatch(userInputHin);
    if (modelYearHinFormatResult) {
      debugPrint(
          'HinDataCubit: modelYearFormatResult test using RegExp: $modelYearHinFormatResult');
    }

    RegExp currentHinFormatRegExp = RegExp(r'^\w{1}[A-Za-z]{2}\w{5}[A-La-l]{1}\d{1}\d{2}$');
    bool currentHinYearFormatResult = currentHinFormatRegExp.hasMatch(userInputHin);
    if (currentHinYearFormatResult) {
      debugPrint(
          'HinDataCubit: currentHinYearFormatResult test using RegExp: $currentHinYearFormatResult');
    }
  } //validate

  // void validateHin(String userInputHin) {
  //   RegExp straightYearHinFormatRegExp = RegExp(r'^[A-Za-z]{3}\d{5}\d{2}\d{2}$');
  //   bool straightYearHinFormatResult = straightYearHinFormatRegExp.hasMatch(userInputHin);
  //   if (straightYearHinFormatResult) {
  //     // debugPrint('straightYearFormatResult test using RegExp: $straightYearHinFormatResult');
  //   }
  //   RegExp modelYearHinFormatRegExp = RegExp(r'^[A-Za-z]{3}\d{5}[M-m]{1}\d{2}[A-La-l]{1}$');
  //   bool modelYearHinFormatResult = modelYearHinFormatRegExp.hasMatch(userInputHin);
  //   if (modelYearHinFormatResult) {
  //     // debugPrint('modelYearFormatResult test using RegExp: $modelYearHinFormatResult');
  //   }
  //
  //   RegExp currentHinFormatRegExp = RegExp(r'^[A-Za-z]{3}\d{5}[A-La-l]{1}\d{1}\d{2}$');
  //   bool currentHinYearFormatResult = currentHinFormatRegExp.hasMatch(userInputHin);
  //   if (currentHinYearFormatResult) {
  //     // debugPrint('currentHinYearFormatResult test using RegExp: $currentHinYearFormatResult');
  //   }
  //
  //   RegExp numericRegExp = RegExp(r'\d');
  //   RegExp alphaRegExp = RegExp(r'[a-zA-Z]');
  //   String validateHinValue = userInputHin.substring(0, 12);
  //
  //   /// TODO: check each HIN location for numeric or alpha
  //   /// Numeric check
  //   bool hin0Numeric = numericRegExp.hasMatch(validateHinValue[0]);
  //   bool hin1Numeric = numericRegExp.hasMatch(validateHinValue[1]);
  //   bool hin2Numeric = numericRegExp.hasMatch(validateHinValue[2]);
  //   bool hin3Numeric = numericRegExp.hasMatch(validateHinValue[3]);
  //   bool hin4Numeric = numericRegExp.hasMatch(validateHinValue[4]);
  //   bool hin5Numeric = numericRegExp.hasMatch(validateHinValue[5]);
  //   bool hin6Numeric = numericRegExp.hasMatch(validateHinValue[6]);
  //   bool hin7Numeric = numericRegExp.hasMatch(validateHinValue[7]);
  //   bool hin8Numeric = numericRegExp.hasMatch(validateHinValue[8]);
  //   bool hin9Numeric = numericRegExp.hasMatch(validateHinValue[9]);
  //   bool hin10Numeric = numericRegExp.hasMatch(validateHinValue[10]);
  //   bool hin11Numeric = numericRegExp.hasMatch(validateHinValue[11]);
  //
  //   /// Alpha check
  //   bool hin0Alpha = alphaRegExp.hasMatch(validateHinValue[0]);
  //   bool hin1Alpha = alphaRegExp.hasMatch(validateHinValue[1]);
  //   bool hin2Alpha = alphaRegExp.hasMatch(validateHinValue[2]);
  //   bool hin3Alpha = alphaRegExp.hasMatch(validateHinValue[3]);
  //   bool hin4Alpha = alphaRegExp.hasMatch(validateHinValue[4]);
  //   bool hin5Alpha = alphaRegExp.hasMatch(validateHinValue[5]);
  //   bool hin6Alpha = alphaRegExp.hasMatch(validateHinValue[6]);
  //   bool hin7Alpha = alphaRegExp.hasMatch(validateHinValue[7]);
  //   bool hin8Alpha = alphaRegExp.hasMatch(validateHinValue[8]);
  //   bool hin9Alpha = alphaRegExp.hasMatch(validateHinValue[9]);
  //   bool hin10Alpha = alphaRegExp.hasMatch(validateHinValue[10]);
  //   bool hin11Alpha = alphaRegExp.hasMatch(validateHinValue[11]);
  //
  //   /// TODO: check to see if the HIN is straight year, Model year or Current
  //   /// HIN format: 0 1 2 3 4 5 6 7 8 9 10 11 (12 digits)
  //   /// *Straight Year November 1972 to July 1984*
  //   /// 0 1 2 are alpha but 0 can be numeric for MIC
  //   /// 3 4 5 6 7 are alpha numeric for S/N
  //   /// 8 9 are numeric for month of production
  //   /// 10 11 are for year of production
  //   /// No model year!
  //   if ((hin0Alpha || hin10Numeric) &&
  //       hin1Alpha &&
  //       hin2Alpha &&
  //       hin8Numeric &&
  //       hin9Numeric &&
  //       hin10Numeric &&
  //       hin11Numeric) {
  //     // debugPrint('In check for Straight Year and HIN: $userInputHin');
  //     if ((validateHinValue[8] == '1' || validateHinValue[8] == '0') &&
  //         (validateHinValue[9] == '1' ||
  //             validateHinValue[9] == '2' ||
  //             validateHinValue[9] == '3' ||
  //             validateHinValue[9] == '4' ||
  //             validateHinValue[9] == '5' ||
  //             validateHinValue[9] == '6' ||
  //             validateHinValue[9] == '7' ||
  //             validateHinValue[9] == '8' ||
  //             validateHinValue[9] == '9')) {
  //       // debugPrint('In check for Straight Year and HIN checking for valid month: $userInputHin');
  //     }
  //   }
  //
  //   /// *Model year November 1972 to July 1984*
  //   /// 0 1 2 are alpha but 0 can be numeric for MIC
  //   /// 3 4 5 6 7 are alpha numeric for S/N
  //   /// 8 is an M always
  //   /// 9 10 are numeric for model year
  //   /// 1984 to 1999 or 2000 to current year 2023
  //   /// 11 is alpha for month (A - L) (same as current HIN)
  //   /// No production year!
  //   /// *Current HIN August 1984 to present*
  //   /// 0 1 2 are MIC and 1 2 are alpha
  //   /// 3 4 5 6 7 are serial number and are alpha numeric
  //   /// 8 is alpha for month (A - L)
  //   /// 9 is the production year
  //   /// 10 and 11 are the model year and need to be used to change the production year format
  //   /// 1984 to 1999 or 2000 to current year 2023
  //   ///
  // }

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

  List<HinDataModel> himWithMyearResults(
      String mic, String earlyHinWithMyear, String monthOfCert, String serialNumber) {
    List<HinDataModel> tempResults = [];
    HinDataModel hinDataModel = HinDataModel(
      manufIdentCode: mic,
      hullSerialNumber: serialNumber,
      monthOfProduction: monthOfCert,
      modelYear: '19$earlyHinWithMyear',
      yearOfProduction: 'N/A',
    );
    // tempResults.add(hinDataModel);
    // debugPrint('In himWithMyearResults: $tempResults');
    tempResults.add(hinDataModel);
    return tempResults;
  } // himWithMyearResults

  List<HinDataModel> hinStraightYearFormat_1972_1984(
      String mic, String currentHinYear, String currentHinModelMonthValue, String serialNumber) {
    List<HinDataModel> tempResults = [];
    HinDataModel hinDataModel = HinDataModel(
      manufIdentCode: mic,
      hullSerialNumber: serialNumber,
      monthOfProduction: currentHinModelMonthValue,
      modelYear: 'N/A',
      yearOfProduction: '19$currentHinYear',
    );
    tempResults.add(hinDataModel);
    // debugPrint('In himWithMyearResults: $tempResults');
    tempResults.add(hinDataModel);
    return tempResults;
  }

  List<HinDataModel> hinCurrentFormatYear2000(
      String mic, String currentHinYear, String currentHinModelMonthValue, String serialNumber) {
    List<HinDataModel> tempResults = [];
    HinDataModel hinDataModel = HinDataModel(
      manufIdentCode: mic,
      hullSerialNumber: serialNumber,
      monthOfProduction: currentHinModelMonthValue,
      modelYear: currentHinYear,
      yearOfProduction: currentHinYear,
    );
    tempResults.add(hinDataModel);
    // debugPrint('In himWithMyearResults: $tempResults');
    tempResults.add(hinDataModel);
    return tempResults;
  }

  List<HinDataModel> hinCurrentFormatYear1984_1999(
      String mic, String currentHinYear, String currentHinModelMonthValue, String serialNumber) {
    List<HinDataModel> tempResults = [];
    HinDataModel hinDataModel = HinDataModel(
      manufIdentCode: mic,
      hullSerialNumber: serialNumber,
      monthOfProduction: currentHinModelMonthValue,
      modelYear: currentHinYear,
      yearOfProduction: currentHinYear,
    );
    tempResults.add(hinDataModel);
    // debugPrint('In himWithMyearResults: $tempResults');
    tempResults.add(hinDataModel);
    return tempResults;
  }
}
