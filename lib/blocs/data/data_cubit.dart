import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hull_identification_number/models/custom_error.dart';
import 'package:hull_identification_number/models/hin_data_model.dart';
import 'package:hull_identification_number/models/mic_data_model.dart';

import '../../repositories/mic_repository.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  final MicRepository repository;
  DataCubit(this.repository) : super(DataState.initial()) {
    getMicDataList('');
  }
  void getMicDataList(String micResultFromHin) async {
    try {
      final micDataList = repository.getMicData();
      dynamic tempValue = micResultFromHin;
      // debugPrint('in DataCubit getMicDataList showing micResultFromHin: $micResultFromHin');
      // for (int i = 0; i < micDataList.length; i++) {
      //   if (micDataList[i] == tempValue) {
      //     debugPrint('Found the MIC: ${[i]}');
      //   }
      // }
      emit(state.copyWith(micDataModel: const MicDataModel()));
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: DataStatus.error,
        error: e,
      ));
    }
  }
} // class
