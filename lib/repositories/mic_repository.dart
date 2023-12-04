import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hull_identification_number/models/mic_data_model.dart';

class MicRepository {
  void getMicData() {
    // Your JSON data
    //   String jsonData = '''
    //   {
    //     "MICDDATA": [
    //       {
    //         "MIC": "4WN",
    //         "Company": "FOUR WINNS INC",
    //         "Address": "4 WINN WAY",
    //         "City": "CADILLAC",
    //         "State": "MI"
    //       },
    //       {
    //         "MIC": "AAA",
    //         "Company": "LA VIDA YACHT SALES",
    //         "Address": "PO BOX 8300",
    //         "City": "ST THOMAS",
    //         "State": "VI"
    //       },
    //       {
    //         "MIC": "AAB",
    //         "Company": "ALL-A-BOARD PONTOONS",
    //         "Address": "211 S MULBERRY ST",
    //         "City": "FARINA",
    //         "State": "IL"
    //       },
    //       {
    //         "MIC": "AAC",
    //         "Company": "ALL CRAFT MARINE LLC",
    //         "Address": "40047 COUNTY RD 54 E",
    //         "City": "ZEPHYRHILLS",
    //         "State": "FL"
    //       },
    //       {
    //         "MIC": "AAD",
    //         "Company": "AARON HINES DESIGNS",
    //         "Address": "197 LANDFALL DR",
    //         "City": "EDEN",
    //         "State": "NC"
    //       }
    //     ]
    //   }
    // ''';
    // final micDataSet = await rootBundle.loadString('lib/mic_data/mic_data.json');
    String jsonFilePath =
        '/Users/Admin/Documents/DevelopmentProjects/ExperimentalTrainingProjects/hull_identification_number/lib/mic_data/mic_data.json';

    String jsonData = File(jsonFilePath).readAsStringSync();

// Decode the JSON data
    Map<String, dynamic> decodedData = jsonDecode(jsonData);

// Find the entry with "MIC": "AAD"
    Map<String, dynamic> micAadEntry =
        decodedData['MICDDATA'].firstWhere((entry) => entry['MIC'] == 'AAD', orElse: () => null);

// Print the result
    if (micAadEntry != null) {
      print("MIC AAD Entry: $micAadEntry");
    } else {
      print("MIC AAD not found");
    }
    // final List<Map<String, dynamic>> micData = jsonData['MICDDATA'].cast<Map<String, dynamic>>();
    // // debugPrint('Trying another repo JSON solution: $micData');
    // dynamic micValueToFind =
    //     'MIC: 4WN, Company: FOUR WINNS INC, Address: 4 WINN WAY, City: CADILLAC, State: MI';
    // debugPrint('This is micData[0]: ${micData[0]}');
    // for (int i = 0; i <= micData.length; i++) {
    //   if (micData[i] == micValueToFind) {
    //     debugPrint('found the value: $micValueToFind');
    //   }
    //   debugPrint('In for loop : $i');
    // }
    // return micData;
    // // debugPrint('In repo inside of getMicData');
    // try {
    //   final String micDataSet = await rootBundle.loadString('lib/mic_data/mic_data.json');
    //   final micDataSetJson = await jsonDecode(micDataSet);
    //   final micDataSetList = List<MicDataModel>.of(
    //     micDataSetJson['MICDDATA'].map<MicDataModel>(
    //       (json) {
    //         return MicDataModel(
    //           mic: json['MIC'],
    //           company: json['Company'],
    //           address: json['Address'],
    //           city: json['City'],
    //           state: json['State'],
    //         );
    //       },
    //     ),
    //   );
    //   // debugPrint('Test of index 0 of the micDataSetJson${micDataSetList[0]}');
    //   dynamic tempCheckValue = 'MAC';
    //   if (micDataSetList.contains(tempCheckValue)) {
    //     debugPrint('Found the match in the if');
    //   }
    //   return micDataSetList;
    // } catch (e) {
    //   debugPrint('Error is: $e');
    //   rethrow;
    // }
    // } //future
  }
}
// "MIC": "4WN",
// "Company": "FOUR WINNS INC",
// "Address": "4 WINN WAY",
// "City": "CADILLAC",
// "State": "MI"
