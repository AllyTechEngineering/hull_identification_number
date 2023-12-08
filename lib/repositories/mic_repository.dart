import 'dart:convert';
import 'dart:async';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/mic_data_model.dart';
// import 'package:path_provider/path_provider.dart';

class MicRepository {
  Future<List<MicDataModel>> getMicData(String userMicEnteredValue) async {
    try {
      if (userMicEnteredValue.isEmpty) {
        userMicEnteredValue = '';
      }
      final String micDataFile =
          await rootBundle.loadString('lib/mic_data/modified_mic_data_v2.json');
      // debugPrint('lib/mic_data/mic_data.json lib/mic_data/mic_data.json: $micDataFile');
      final micDataJson = await jsonDecode(micDataFile);
      final micDataList = List<MicDataModel>.of(
        micDataJson[userMicEnteredValue].map<MicDataModel>(
          (json) {
            return MicDataModel(
              company: json['Company'],
              address: json['Address'],
              city: json['City'],
              state: json['State'],
            );
          },
        ),
      );
      // debugPrint('this is micDataList: $micDataList');
      return micDataList;
    } catch (e) {
      debugPrint('Error e: $e');
      rethrow;
    }
  }
}
