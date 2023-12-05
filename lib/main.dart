import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hull_identification_number/blocs/data/data_cubit.dart';
import 'package:hull_identification_number/models/mic_data_model.dart';
import 'package:hull_identification_number/repositories/mic_repository.dart';
import 'package:hull_identification_number/screens/home_screen_two.dart';
import 'package:hull_identification_number/screens/definition_screen.dart';
import 'package:hull_identification_number/screens/settings_screen.dart';
import 'package:hull_identification_number/utilities/theme.dart';
// import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreenTwo();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'definition_screen',
          builder: (BuildContext context, GoRouterState state) {
            return const DefinitionScreen();
          },
        ),
        GoRoute(
          path: 'settings_screen',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
        // GoRoute(
        //   path: 'data_table_list_screen',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return DataListScreen();
        //   },
        // ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MicRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DataCubit>(
            create: (context) => DataCubit(repository: MicRepository()),
          )
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          title: 'Portsmouth',
          theme: appTheme,
        ),
      ),
    );
  }
}

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _hinController = TextEditingController();
//   final MicRepository micRepository = MicRepository();
//   MicDataModel micDataModel = const MicDataModel();
//   String _decodedInfo = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<DataCubit, DataState>(
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('HIN'),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextField(
//                   controller: _hinController,
//                   decoration: const InputDecoration(labelText: 'Enter HIN'),
//                   // errorText: _errorText.isNotEmpty ? _errorText : null,
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     String tempMicValue = decodeHIN();
//                     context.read<DataCubit>().getUserEnteredMicData(tempMicValue);
//                     debugPrint('TempMicValue from decodedHIN: $tempMicValue');
//                   },
//                   child: const Text('Decode HIN'),
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _hinController.clear();
//                       _decodedInfo = '';
//                       context.read<DataCubit>().getUserEnteredMicData('111');
//                     });
//                   },
//                   child: const Text('Clear HIN'),
//                 ),
//                 const SizedBox(height: 16.0),
//                 BlocBuilder<DataCubit, DataState>(
//                   builder: (context, state) {
//                     return Text(
//                       _decodedInfo,
//                       style: const TextStyle(fontSize: 18.0),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 BlocBuilder<DataCubit, DataState>(
//                   builder: (context, state) {
//                     if (state is LoadedState) {
//                       final micResults = state.micData;
//                       debugPrint('In UI micResults: ${micResults[0].company}');
//                       return Text(
//                           'Manuf: ${micResults[0].company}\nAddress: ${micResults[0].address}\nCity: ${micResults[0].city}\nState: ${micResults[0].state}');
//                     }
//                     return Text('');
//                   },
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   String decodeHIN() {
//     int earlyHinWithMyearToInt = 0;
//     int currentYearValue = 0;
//     String micUserDataResult = '';
//     String hin = _hinController.text.trim().toUpperCase();
//
//     if (hin.length != 12) {
//       setState(() {
//         // _errorText = 'Invalid HIN length. Please enter 12 characters.';
//         _decodedInfo = '';
//
//         const snackBar = SnackBar(
//           duration: Duration(seconds: 4),
//           content: Text(
//             'Invalid HIN length. Please enter 12 characters.',
//             style: TextStyle(fontSize: 30.0),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       });
//       return micUserDataResult;
//     }
//
//     /// Three HIN Formats
//     /// Straight Year Format (Used November 1, 1972– July 31, 1984)
//     /// ABC 12345   08                    83
//     /// MIC SN      Month of production   Year of production
//     ///
//     /// Current Format (Used exclusively August 1, 1984 to present)
//     /// BMA 45678   H4                    85
//     /// MIC SN      Month of production   Year of production
//
//     String mic = hin.substring(0, 3);
//     // Define regular expressions to check for numeric and alpha characters
//     RegExp numericRegExp = RegExp(r'\d');
//     RegExp alphaRegExp = RegExp(r'[a-zA-Z]');
//     // bool containsNumeric = numericRegExp.hasMatch(mic);
//     // bool containsAlpha = alphaRegExp.hasMatch(mic);
// // Iterate through each character in the string
//     for (int i = 0; i < mic.length; i++) {
//       String character = mic[i];
//
//       // Check if the character is numeric
//       bool isNumeric = numericRegExp.hasMatch(mic[i]);
//       bool micHasNumericAt0 = numericRegExp.hasMatch(mic[0]);
//       debugPrint('micHasNumericAt0: $micHasNumericAt0');
//       bool micHasNumericAt1 = numericRegExp.hasMatch(mic[1]);
//       debugPrint('micHasNumericAt1: $micHasNumericAt1');
//       bool micHasNumericAt2 = numericRegExp.hasMatch(mic[2]);
//       debugPrint('micHasNumericAt2: $micHasNumericAt2');
//
//       // Check if the character is alpha
//       bool isAlpha = alphaRegExp.hasMatch(mic[i]);
//
//       // Handle the exception at each location
//       if (micHasNumericAt1 || micHasNumericAt2) {
//         debugPrint('Character at position $i in the string is numeric.');
//         setState(() {
//           // _errorText = 'Invalid HIN MIC Code - Please Check';
//           _decodedInfo = '';
//
//           const snackBar = SnackBar(
//             duration: Duration(seconds: 4),
//             content: Text(
//               'Error in MIC - first three characters of the HIN',
//               style: TextStyle(fontSize: 30.0),
//             ),
//           );
//           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//         });
//         return micUserDataResult;
//         // Handle the exception here, for example, show an error message to the user.
//       }
//
//       if (isAlpha) {
//         debugPrint('Character at position $i in the string is alpha.');
//
//         // Continue with the normal flow of your application.
//       }
//     }
//     micUserDataResult = mic;
//     debugPrint('This is the MIC: $mic');
//     String serialNumber = hin.substring(3, 8);
//     debugPrint('This is the SN: $serialNumber');
//     String earlyHinWithM = hin.substring(8, 9);
//
//     debugPrint('This is the earlyHinWithM: $earlyHinWithM');
//
//     /// Model Year Format (Used November 1, 1972– July 31, 1984)
//     /// XYZ 45678   M                   83               A
//     /// MIC SN      Denotes model/year  production year  production month
//     if (earlyHinWithM == 'M') {
//       debugPrint('This is early HIN with M: $earlyHinWithM');
//       String earlyHinWithMyear = hin.substring(9, 11);
//       try {
//         earlyHinWithMyearToInt = int.parse(earlyHinWithMyear);
//         debugPrint('String to Int: $earlyHinWithMyearToInt');
//       } catch (e) {
//         debugPrint('Error parsing the string: $e');
//         var snackBar = const SnackBar(
//           duration: Duration(seconds: 2),
//           content: Text(
//             'There is an error in your HIN format. Check the HIN format.',
//             style: TextStyle(fontSize: 30.0),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       }
//       String monthOfCert = decodeMonthModelYearFormat(hin.substring(11));
//       debugPrint('Month of Cert: $monthOfCert');
//       if (earlyHinWithMyearToInt >= 72) {
//         debugPrint('Early HIN with M year: 19$earlyHinWithMyear');
//       }
//
//       setState(() {
//         _decodedInfo =
//             'Decoded HIN Results\nManufacturer ID Code: $mic\nManuf. Year: 19$earlyHinWithMyear\nManuf. Month: $monthOfCert\nSerial Number: $serialNumber';
//       });
//     } //if early HIN Model Year M
//
//     if (earlyHinWithM != 'M') {
//       String currentHinModelMonth = hin.substring(8, 9);
//       debugPrint('This is the currentHinModelMonth: $currentHinModelMonth');
//       String currentHinModelMonthValue = decodeMonthCurrentFormat(currentHinModelMonth);
//       String currentHinYear = hin.substring(10);
//       debugPrint('This is the currentHinYear: $currentHinYear');
//       try {
//         currentYearValue = int.parse(currentHinYear);
//       } catch (e) {
//         debugPrint('Error parsing the string: $e');
//         var snackBar = const SnackBar(
//           duration: Duration(seconds: 2),
//           content: Text(
//             'There is an error in your HIN format. Check the HIN format.',
//             style: TextStyle(fontSize: 30.0),
//           ),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       }
//
//       if (currentYearValue >= 0 && currentYearValue <= 24) {
//         debugPrint('The year is 20$currentHinYear');
//         setState(() {
//           _decodedInfo =
//               'Decoded HIN Results:\nManufacturer ID Code: $mic\nManuf. Year: 20$currentHinYear\nManuf. Month: $currentHinModelMonthValue\nSerial Number: $serialNumber';
//         });
//       } else if (currentYearValue >= 84 && currentYearValue <= 99) {
//         debugPrint('The year is 19$currentHinYear');
//         setState(() {
//           _decodedInfo =
//               'Decoded HIN Results:\nManufacturer: $mic\nYear: 19$currentHinYear\nMonth: $currentHinModelMonthValue\nSerial Number: $serialNumber';
//         });
//       }
//     }
//     return micUserDataResult;
//   } // decodeHIN
//
//   String decodeMonthModelYearFormat(String code) {
//     switch (code.toUpperCase()) {
//       case 'A':
//         return 'August';
//       case 'B':
//         return 'September';
//       case 'C':
//         return 'October';
//       case 'D':
//         return 'November';
//       case 'E':
//         return 'December';
//       case 'F':
//         return 'January';
//       case 'G':
//         return 'February';
//       case 'H':
//         return 'March';
//       case 'I':
//         return 'April';
//       case 'J':
//         return 'May';
//       case 'K':
//         return 'June';
//       case 'L':
//         return 'July';
//       default:
//         return 'Unknown';
//     }
//   }
//
//   String decodeMonthCurrentFormat(String code) {
//     switch (code.toUpperCase()) {
//       case 'A':
//         return 'January';
//       case 'B':
//         return 'February';
//       case 'C':
//         return 'March';
//       case 'D':
//         return 'April';
//       case 'E':
//         return 'May';
//       case 'F':
//         return 'June';
//       case 'G':
//         return 'July';
//       case 'H':
//         return 'August';
//       case 'I':
//         return 'September';
//       case 'J':
//         return 'October';
//       case 'K':
//         return 'November';
//       case 'L':
//         return 'December';
//       default:
//         return 'Unknown';
//     }
//   }
// } //class
