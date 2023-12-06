import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hull_identification_number/blocs/data/data_cubit.dart';
import 'package:hull_identification_number/models/mic_data_model.dart';
import 'package:hull_identification_number/repositories/mic_repository.dart';
import 'package:hull_identification_number/utilities/decode_hin_class.dart';
import 'package:hull_identification_number/utilities/responsive_adaptive_class.dart';

class HomeScreenTwo extends StatefulWidget {
  const HomeScreenTwo({super.key});

  @override
  State<HomeScreenTwo> createState() => _HomeScreenTwoState();
}

class _HomeScreenTwoState extends State<HomeScreenTwo> {
  final TextEditingController hinController = TextEditingController();
  final MicRepository micRepository = MicRepository();
  final ResponsiveAdaptiveClass responsiveAdaptiveClass = ResponsiveAdaptiveClass();
  final DecodeHinClass decodeHinClass = DecodeHinClass();
  final List<String> micDataForListView = [];
  MicDataModel micDataModel = const MicDataModel();
  String decodedInfo = '';

  @override
  Widget build(BuildContext context) {
    responsiveAdaptiveClass.orientation = MediaQuery.of(context).orientation;
    responsiveAdaptiveClass.size = MediaQuery.of(context).size;
    responsiveAdaptiveClass.height = responsiveAdaptiveClass.size.height;
    responsiveAdaptiveClass.width = responsiveAdaptiveClass.size.width;

    return BlocBuilder<DataCubit, DataState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.description_outlined,
                // color: Colors.white,
              ),
              // iconSize: 40.0,
              onPressed: () => context.go('/definition_screen'),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  // color: Colors.white,
                ),
                onPressed: () => context.go('/settings_screen'),
              ),
            ],
            centerTitle: true,
            title: Text(
              'Boat HIN Decoder',
              style: TextStyle(
                  fontSize: responsiveAdaptiveClass.appBarTitleFontSize =
                      responsiveAdaptiveClass.selectAppBarTitleFontSize()),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ocean_background.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 1.0,
                image: AssetImage('assets/images/ocean_background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: TextField(
                    cursorColor: Colors.white,
                    controller: hinController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(width: 4.0, color: Colors.black),
                      ),
                      hintStyle: Theme.of(context).textTheme.displayLarge,
                      hintText: 'Enter a 12 digit HIN...',
                      prefixIcon: const Icon(
                        Icons.search,
                        // size: height * 0.08,
                      ),
                    ),
                    // errorText: _errorText.isNotEmpty ? _errorText : null,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFDAFFFB),
                        Color(0xFF176B87),
                      ],
                      stops: [0.0, 0.8],
                    ),
                    // color: Colors.deepPurple.shade300,
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      String tempMicValue = decodeHIN();
                      context.read<DataCubit>().getUserEnteredMicData(tempMicValue);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 10.0,
                        // fixedSize: Size((width * 0.75), (height / 5.5)),
                        fixedSize: Size(
                            responsiveAdaptiveClass.elevatedButtonWidth =
                                responsiveAdaptiveClass.selectElevatedButtonWidth(),
                            responsiveAdaptiveClass.elevatedButtonHeight =
                                responsiveAdaptiveClass.selectElevatedButtonHeight()),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 3.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        backgroundColor: Colors.transparent),
                    child: Text(
                      'Decode HIN',
                      style: TextStyle(
                          fontSize: responsiveAdaptiveClass.classFontSize =
                              responsiveAdaptiveClass.selectClassFontSize(),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFDAFFFB),
                        Color(0xFF176B87),
                      ],
                      stops: [0.0, 0.8],
                    ),
                    // color: Colors.deepPurple.shade300,
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        hinController.clear();
                        decodedInfo = '';
                        context.read<DataCubit>().getUserEnteredMicData('111');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 10.0,
                        // fixedSize: Size((width * 0.75), (height / 5.5)),
                        fixedSize: Size(
                            responsiveAdaptiveClass.elevatedButtonWidth =
                                responsiveAdaptiveClass.selectElevatedButtonWidth(),
                            responsiveAdaptiveClass.elevatedButtonHeight =
                                responsiveAdaptiveClass.selectElevatedButtonHeight()),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 3.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        backgroundColor: Colors.transparent),
                    child: Text(
                      'Clear HIN',
                      style: TextStyle(
                          fontSize: responsiveAdaptiveClass.classFontSize =
                              responsiveAdaptiveClass.selectClassFontSize(),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                BlocBuilder<DataCubit, DataState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            decodedInfo,
                            style: const TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Divider(
                    thickness: 2,
                    endIndent: 2,
                    indent: 2,
                  ),
                ),
                BlocBuilder<DataCubit, DataState>(
                  builder: (context, state) {
                    if (state is LoadedState) {
                      final micResults = state.micData;
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manuf: ${micResults[0].company}',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                              'Address: ${micResults[0].address}',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                              'City: ${micResults[0].city}',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                              'State: ${micResults[0].state}',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }
                    return Text('');
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  } //Widget build

  String decodeHIN() {
    int earlyHinWithMyearToInt = 0;
    int currentYearValue = 0;
    String micUserDataResult = '';
    String hin = hinController.text.trim().toUpperCase();

    if (hin.length != 12) {
      hinLengthError();
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
    // Define regular expressions to check for numeric and alpha characters
    RegExp numericRegExp = RegExp(r'\d');
    RegExp alphaRegExp = RegExp(r'[a-zA-Z]');

    // Iterate through each character in the string
    for (int i = 0; i < mic.length; i++) {
      bool micHasNumericAt1 = numericRegExp.hasMatch(mic[1]);
      bool micHasNumericAt2 = numericRegExp.hasMatch(mic[2]);
      // Check if the character is alpha
      bool isAlpha = alphaRegExp.hasMatch(mic[i]);
      // Handle the exception at each location
      if (micHasNumericAt1 || micHasNumericAt2) {
        hinMicError();
        return micUserDataResult;
        // Handle the exception here, for example, show an error message to the user.
      }
    }
    micUserDataResult = mic;
    String serialNumber = hin.substring(3, 8);
    String earlyHinWithM = hin.substring(8, 9);

    /// Model Year Format (Used November 1, 1972– July 31, 1984)
    /// XYZ 45678   M                   83               A
    /// MIC SN      Denotes model/year  production year  production month
    if (earlyHinWithM == 'M') {
      String earlyHinWithMyear = hin.substring(9, 11);
      String monthOfCert = decodeHinClass.decodeMonthModelYearFormat(hin.substring(11));
      himWithMyearResults(mic, earlyHinWithMyear, monthOfCert, serialNumber);
    } //if early HIN Model Year M

    if (earlyHinWithM != 'M') {
      String currentHinModelMonth = hin.substring(8, 9);
      String currentHinModelMonthValue =
          decodeHinClass.decodeMonthCurrentFormat(currentHinModelMonth);
      String currentHinYear = hin.substring(10, 12);

      try {
        currentYearValue = int.parse(currentHinYear);
      } catch (e) {
        debugPrint('Error parsing the string: $e');
        hinFormatError();
      }
      DateTime now = DateTime.now();
      int currentYear = now.year;
      currentYear = currentYear - 2000;
      debugPrint(
          'this is the current year value: $currentYear\n this is the decoded hin year: $currentYearValue');
      if (currentYearValue >= 0 && currentYearValue <= currentYear) {
        hinCurrentFormatYear2000(mic, currentHinYear, currentHinModelMonthValue, serialNumber);
      } else if (currentYearValue >= 84 && currentYearValue <= 99) {
        hinCurrentFormatYear1984_1999(mic, currentHinYear, currentHinModelMonthValue, serialNumber);
      }
    }
    return micUserDataResult;
  } // decodeHIN

  void hinLengthError() {
    setState(() {
      // _errorText = 'Invalid HIN length. Please enter 12 characters.';
      decodedInfo = '';

      const snackBar = SnackBar(
        duration: Duration(seconds: 4),
        content: Text(
          'Invalid HIN length. Please enter 12 characters.',
          style: TextStyle(fontSize: 30.0),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void hinMicError() {
    setState(() {
      decodedInfo = '';
      const snackBar = SnackBar(
        duration: Duration(seconds: 4),
        content: Text(
          'Error in MIC - first three characters of the HIN',
          style: TextStyle(fontSize: 30.0),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void hinWithMyearError() {
    var snackBar = const SnackBar(
      duration: Duration(seconds: 2),
      content: Text(
        'There is an error in your HIN format. Check the HIN format.',
        style: TextStyle(fontSize: 30.0),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void himWithMyearResults(
      String mic, String earlyHinWithMyear, String monthOfCert, String serialNumber) {
    setState(() {
      decodedInfo =
          'Results:\nManuf. Code: $mic\nManuf. Year: 19$earlyHinWithMyear\nManuf. Month: $monthOfCert\nSerial Number: $serialNumber';
    });
  }

  void hinFormatError() {
    var snackBar = const SnackBar(
      duration: Duration(seconds: 2),
      content: Text(
        'There is an error in your HIN format. Check the HIN format.',
        style: TextStyle(fontSize: 30.0),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void hinCurrentFormatYear2000(
      String mic, String currentHinYear, String currentHinModelMonthValue, String serialNumber) {
    setState(() {
      decodedInfo =
          'Results:\nManuf. Code: $mic\nManuf. Year: 20$currentHinYear\nManuf. Month: $currentHinModelMonthValue\nSerial Number: $serialNumber';
    });
  }

  void hinCurrentFormatYear1984_1999(
      String mic, String currentHinYear, String currentHinModelMonthValue, String serialNumber) {
    setState(() {
      decodedInfo =
          'Results:\nManuf. Code: $mic\nYear: 19$currentHinYear\nMonth: $currentHinModelMonthValue\nSerial Number: $serialNumber';
    });
  }
}
