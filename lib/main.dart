import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hull_identification_number/blocs/data/data_cubit.dart';
import 'package:hull_identification_number/repositories/mic_repository.dart';
// import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MicRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DataCubit>(
            create: (context) => DataCubit(
              MicRepository(),
            ),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('HIN Decoder'),
            ),
            body: const HinDecoder(),
          ),
        ),
      ),
    );
  }
}

class HinDecoder extends StatefulWidget {
  const HinDecoder({super.key});

  @override
  _HinDecoderState createState() => _HinDecoderState();
}

class _HinDecoderState extends State<HinDecoder> {
  final TextEditingController _hinController = TextEditingController();
  final MicRepository micRepository = MicRepository();
  String _decodedInfo = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('HIN'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _hinController,
                  decoration: const InputDecoration(labelText: 'Enter HIN'),
                  // errorText: _errorText.isNotEmpty ? _errorText : null,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    String tempMicValue = decodeHIN();
                    context.read<DataCubit>().getMicDataList(tempMicValue);
                  },
                  child: const Text('Decode HIN'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hinController.clear();
                      _decodedInfo = '';
                    });
                  },
                  child: const Text('Clear HIN'),
                ),
                const SizedBox(height: 16.0),
                Text(
                  _decodedInfo,
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Details:\nCompany: ${state.micDataModel.company}\nAddress: ${state.micDataModel.address}\nCity: ${state.micDataModel.city}\nState: ${state.micDataModel.state}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// TODO: use try catch for any int.parse in case user malformed HIN
  ///
  String decodeHIN() {
    int earlyHinWithMyearToInt = 0;
    int currentYearValue = 0;
    String micUserDataResult = '';
    String hin = _hinController.text.trim().toUpperCase();

    if (hin.length != 12) {
      setState(() {
        // _errorText = 'Invalid HIN length. Please enter 12 characters.';
        _decodedInfo = '';

        const snackBar = SnackBar(
          duration: Duration(seconds: 4),
          content: Text(
            'Invalid HIN length. Please enter 12 characters.',
            style: TextStyle(fontSize: 30.0),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      return micUserDataResult;
    }

    /// Three HIN Formats
    /// Straight Year Format (Used November 1, 1972– July 31, 1984)
    /// ABC 12345   08                    83
    /// MIC SN      Month of production   Year of production
    ///
    /// Current Format (Used exclusively August 1, 1984 to present)
    /// BMA 45678   H4                    85
    /// MIC SN      Month of production   Year of production

    String mic = hin.substring(0, 3);
    micUserDataResult = mic;
    debugPrint('This is the MIC: $mic');
    String serialNumber = hin.substring(3, 8);
    debugPrint('This is the SN: $serialNumber');
    String earlyHinWithM = hin.substring(8, 9);

    debugPrint('This is the earlyHinWithM: $earlyHinWithM');

    /// Model Year Format (Used November 1, 1972– July 31, 1984)
    /// XYZ 45678   M                   83               A
    /// MIC SN      Denotes model/year  production year  production month
    if (earlyHinWithM == 'M') {
      debugPrint('This is early HIN with M: $earlyHinWithM');
      String earlyHinWithMyear = hin.substring(9, 11);
      try {
        earlyHinWithMyearToInt = int.parse(earlyHinWithMyear);
        debugPrint('String to Int: $earlyHinWithMyearToInt');
      } catch (e) {
        debugPrint('Error parsing the string: $e');
        var snackBar = const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'There is an error in your HIN format. Check the HIN format.',
            style: TextStyle(fontSize: 30.0),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      String monthOfCert = decodeMonthModelYearFormat(hin.substring(11));
      debugPrint('Month of Cert: $monthOfCert');
      if (earlyHinWithMyearToInt >= 72) {
        debugPrint('Early HIN with M year: 19$earlyHinWithMyear');
      }

      setState(() {
        _decodedInfo =
            'Decoded HIN Results\nManufacturer ID Code: $mic\nManuf. Year: 19$earlyHinWithMyear\nManuf. Month: $monthOfCert\nSerial Number: $serialNumber';
      });
    } //if early HIN Model Year M

    if (earlyHinWithM != 'M') {
      String currentHinModelMonth = hin.substring(8, 9);
      debugPrint('This is the currentHinModelMonth: $currentHinModelMonth');
      String currentHinModelMonthValue = decodeMonthCurrentFormat(currentHinModelMonth);
      String currentHinYear = hin.substring(10);
      debugPrint('This is the currentHinYear: $currentHinYear');
      try {
        currentYearValue = int.parse(currentHinYear);
      } catch (e) {
        debugPrint('Error parsing the string: $e');
        var snackBar = const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            'There is an error in your HIN format. Check the HIN format.',
            style: TextStyle(fontSize: 30.0),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      if (currentYearValue >= 0 && currentYearValue <= 24) {
        debugPrint('The year is 20$currentHinYear');
        setState(() {
          _decodedInfo =
              'Decoded HIN Results:\nManufacturer ID Code: $mic\nManuf. Year: 20$currentHinYear\nManuf. Month: $currentHinModelMonthValue\nSerial Number: $serialNumber';
        });
      } else if (currentYearValue >= 84 && currentYearValue <= 99) {
        debugPrint('The year is 19$currentHinYear');
        setState(() {
          _decodedInfo =
              'Decoded HIN Results:\nManufacturer: $mic\nYear: 19$currentHinYear\nMonth: $currentHinModelMonthValue\nSerial Number: $serialNumber';
        });
      }
    }
    return micUserDataResult;
  } // decodeHIN

  String decodeMonthModelYearFormat(String code) {
    switch (code.toUpperCase()) {
      case 'A':
        return 'August';
      case 'B':
        return 'September';
      case 'C':
        return 'October';
      case 'D':
        return 'November';
      case 'E':
        return 'December';
      case 'F':
        return 'January';
      case 'G':
        return 'February';
      case 'H':
        return 'March';
      case 'I':
        return 'April';
      case 'J':
        return 'May';
      case 'K':
        return 'June';
      case 'L':
        return 'July';
      default:
        return 'Unknown';
    }
  }

  String decodeMonthCurrentFormat(String code) {
    switch (code.toUpperCase()) {
      case 'A':
        return 'January';
      case 'B':
        return 'February';
      case 'C':
        return 'March';
      case 'D':
        return 'April';
      case 'E':
        return 'May';
      case 'F':
        return 'June';
      case 'G':
        return 'July';
      case 'H':
        return 'August';
      case 'I':
        return 'September';
      case 'J':
        return 'October';
      case 'K':
        return 'November';
      case 'L':
        return 'December';
      default:
        return 'Unknown';
    }
  }
}
