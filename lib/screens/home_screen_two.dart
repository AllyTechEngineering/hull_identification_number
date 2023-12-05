import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hull_identification_number/blocs/data/data_cubit.dart';
import 'package:hull_identification_number/models/mic_data_model.dart';
import 'package:hull_identification_number/repositories/mic_repository.dart';
import 'dart:io';

class HomeScreenTwo extends StatefulWidget {
  const HomeScreenTwo({super.key});

  @override
  State<HomeScreenTwo> createState() => _HomeScreenTwoState();
}

class _HomeScreenTwoState extends State<HomeScreenTwo> {
  final TextEditingController _hinController = TextEditingController();
  final MicRepository micRepository = MicRepository();
  final List<String> micDataForListView = [];
  MicDataModel micDataModel = const MicDataModel();
  String _decodedInfo = '';

  var orientation, size, height, width;
  double fontSizeValue = 0.0;
  double classFontSize = 0.0;
  double appBarTitleFontSize = 0.0;
  double elevatedButtonWidth = 0.0;
  double elevatedButtonHeight = 0.0;
  double classImageHeight = 0.0;
  double classImageWidth = 0.0;
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    height = size.height;
    debugPrint('Device orientation: $orientation width: $width height: $height');
    width = size.width;

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
              'Boating HIN Decoder',
              style: TextStyle(fontSize: appBarTitleFontSize = selectAppBarTitleFontSize()),
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
            child: Column(
              children: [
                ListTile(
                  title: TextField(
                    cursorColor: Colors.white,
                    controller: _hinController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(width: 4.0, color: Colors.black),
                      ),
                      hintStyle: Theme.of(context).textTheme.displayLarge,
                      hintText: 'Enter the 12 digit HIN',
                      prefixIcon: const Icon(
                        Icons.search,
                        // size: height * 0.08,
                      ),
                    ),
                    // errorText: _errorText.isNotEmpty ? _errorText : null,
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    String tempMicValue = decodeHIN();
                    context.read<DataCubit>().getUserEnteredMicData(tempMicValue);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 10.0,
                      // fixedSize: Size((width * 0.75), (height / 5.5)),
                      fixedSize: Size(elevatedButtonWidth = selectElevatedButtonWidth(),
                          elevatedButtonHeight = selectElevatedButtonHeight()),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 3.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      backgroundColor: Colors.transparent),
                  child: Text(
                    'Decode HIN',
                    style: TextStyle(
                        fontSize: classFontSize = selectClassFontSize(),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hinController.clear();
                      _decodedInfo = '';
                      context.read<DataCubit>().getUserEnteredMicData('111');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 10.0,
                      // fixedSize: Size((width * 0.75), (height / 5.5)),
                      fixedSize: Size(elevatedButtonWidth = selectElevatedButtonWidth(),
                          elevatedButtonHeight = selectElevatedButtonHeight()),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 3.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      backgroundColor: Colors.transparent),
                  child: Text(
                    'Clear HIN',
                    style: TextStyle(
                        fontSize: classFontSize = selectClassFontSize(),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16.0),
                BlocBuilder<DataCubit, DataState>(
                  builder: (context, state) {
                    return Container(
                      width: width * 0.65,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _decodedInfo,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                BlocBuilder<DataCubit, DataState>(
                  builder: (context, state) {
                    if (state is LoadedState) {
                      final micResults = state.micData;
                      return Container(
                        width: width * .65,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manuf: ${micResults[0].company}',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Address: ${micResults[0].address}',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'City: ${micResults[0].city}',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'State: ${micResults[0].state}',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
  }

//Widget build
  double selectClassFontSize() {
    if (Platform.isIOS) {
      // small iPhones: 375 w x 667 h
      if ((orientation == Orientation.portrait) && (width >= 375 && height <= 667)) {
        classFontSize = 20.0;
        return classFontSize;
      } else if ((orientation == Orientation.landscape) && (width >= 667 && height <= 375)) {
        classFontSize = 22.0;
        return classFontSize;
      }
      // small iPhones: 375 w x 812 h
      if ((orientation == Orientation.portrait) && (width >= 375 && height <= 812)) {
        classFontSize = 18.0;
        return classFontSize;
      } else if ((orientation == Orientation.landscape) && (width >= 812 && height <= 375)) {
        classFontSize = 18.0;
        return classFontSize;
      }
      // iPhones: 390 w to 430 w x 844 h to 932 h
      if ((orientation == Orientation.portrait) &&
          ((width >= 390 && width <= 430) && (height >= 844 && height <= 932))) {
        classFontSize = 20.0;
        debugPrint('390 w x 932 h Portrait classFontSize: $classFontSize');
        return classFontSize;
      } else if ((orientation == Orientation.landscape) && (width >= 844 && height <= 430)) {
        classFontSize = 22.0;
        debugPrint('390 w x 932 h Landscape classFontSize: $classFontSize');
        return classFontSize;
      }
      // iPads: 744 w to 834 w x 1024 h to 1194 h
      if ((orientation == Orientation.portrait) &&
          ((width >= 744 && width <= 834) && (height >= 1024 && height <= 1194))) {
        classFontSize = 20.0;
        debugPrint(
            'iPads: 744 w to 834 w x 1024 h to 1194 h Portrait classFontSize: $classFontSize');
        return classFontSize;
      } else if ((orientation == Orientation.landscape) &&
          ((height >= 744 && height <= 834) && (width >= 1024 && width <= 1194))) {
        classFontSize = 22.0;
        debugPrint(
            'iPads: 744 w to 834 w x 1024 h to 1194 h Landscape classFontSize: $classFontSize');
        return classFontSize;
      }
    }

    return classFontSize;
  }

  double selectAppBarTitleFontSize() {
    if (Platform.isIOS) {
      // small iPhones: 375 w x 667 h
      if ((orientation == Orientation.portrait) && (width >= 375 && height <= 667)) {
        appBarTitleFontSize = 20.0;
        return appBarTitleFontSize;
      } else if ((orientation == Orientation.landscape) && (width >= 667 && height <= 375)) {
        appBarTitleFontSize = 22.0;
        return appBarTitleFontSize;
      }
      // iPhones: 375 w x 812 h
      if ((orientation == Orientation.portrait) && (width >= 375 && height <= 812)) {
        appBarTitleFontSize = 20.0;
        return appBarTitleFontSize;
      } else if ((orientation == Orientation.landscape) && (width >= 812 && height <= 375)) {
        appBarTitleFontSize = 22.0;
        return appBarTitleFontSize;
      }
      // iPhones: 390 w to 430 w x 844 h to 932 h
      if ((orientation == Orientation.portrait) &&
          ((width >= 390 && width <= 430) && (height >= 844 && height <= 932))) {
        appBarTitleFontSize = 22.0;
        debugPrint('390 w x 932 h Portrait appBarTitleFontSize: $appBarTitleFontSize');
        return appBarTitleFontSize;
      } else if ((orientation == Orientation.landscape) && (width >= 844 && height <= 430)) {
        appBarTitleFontSize = 24.0;
        debugPrint('390 w x 932 h Landscape appBarTitleFontSize: $appBarTitleFontSize');
        return appBarTitleFontSize;
      }
      // iPads: 744 w to 834 w x 1024 h to 1194 h
      if ((orientation == Orientation.portrait) &&
          ((width >= 744 && width <= 834) && (height >= 1024 && height <= 1194))) {
        appBarTitleFontSize = 20.0;
        debugPrint(
            'iPads: 744 w to 834 w x 1024 h to 1194 h Portrait appBarTitleFontSize: $appBarTitleFontSize');
        return appBarTitleFontSize;
      } else if ((orientation == Orientation.landscape) &&
          ((height >= 744 && height <= 834) && (width >= 1024 && width <= 1194))) {
        appBarTitleFontSize = 22.0;
        debugPrint(
            'iPads: 744 w to 834 w x 1024 h to 1194 h Landscape classFontSize: $appBarTitleFontSize');
        return appBarTitleFontSize;
      }
    }

    return appBarTitleFontSize;
  }

  double selectClassImageHeight() {
    if (Platform.isIOS) {
      // small iPhones: 375 w x 667 h
      if ((orientation == Orientation.portrait) && (width >= 375 && height <= 667)) {
        classImageHeight = height * 0.12;
        debugPrint('375 w x 667 h Portrait classImageHeight: $classImageHeight');
        return classImageHeight;
      } else if ((orientation == Orientation.landscape) &&
          (width >= 667 && height <= 375 && (width <= 811))) {
        classImageHeight = height * 0.15;
        debugPrint('375 w x 667 h Landscape classImageHeight: $classImageHeight');
        return classImageHeight;
      }
      // iPhones: 375 w x 812 h
      if ((orientation == Orientation.portrait) && (width >= 375 && height <= 812)) {
        classImageHeight = height * 0.10;
        debugPrint('375 w x 812 h Portrait classImageHeight: $classImageHeight');
        return classImageHeight;
      } else if ((orientation == Orientation.landscape) && (width >= 812 && height <= 375)) {
        classImageHeight = height * 0.15;
        debugPrint('375 w x 812 h Landscape classImageHeight: $classImageHeight');
        return classImageHeight;
      }
      // iPhones: 390 w to 430 w x 844 h to 932 h
      if ((orientation == Orientation.portrait) &&
          ((width >= 390 && width <= 430) && (height >= 844 && height <= 932))) {
        classImageHeight = height * 0.0935;
        debugPrint('390 w x 932 h Portrait classImageHeight: $classImageHeight');
        return classImageHeight;
      } else if ((orientation == Orientation.landscape) && (width >= 844 && height <= 430)) {
        classImageHeight = height * 0.15;
        debugPrint('390 w x 932 h Landscape classImageHeight: $classImageHeight');
        return classImageHeight;
      }
      // iPads: 744 w to 834 w x 1024 h to 1194 h
      if ((orientation == Orientation.portrait) &&
          ((width >= 744 && width <= 834) && (height >= 1024 && height <= 1194))) {
        classImageHeight = height * 0.0935;
        debugPrint(
            'iPads: 744 w to 834 w x 1024 h to 1194 h Portrait classImageHeight: $classImageHeight');
        return classImageHeight;
      } else if ((orientation == Orientation.landscape) &&
          ((height >= 744 && height <= 834) && (width >= 1024 && width <= 1194))) {
        classImageHeight = height * 0.15;
        debugPrint(
            'iPads: 744 w to 834 w x 1024 h to 1194 h Landscape classImageHeight: $classImageHeight');
        return classImageHeight;
      }
    }

    return classImageHeight;
  }

  double selectClassImageWidth() {
    if (Platform.isIOS) {
      // small iPhones: 375 w x 667 h
      if ((orientation == Orientation.portrait) && (width >= 375 && height <= 667)) {
        classImageWidth = width * 0.214;
        debugPrint('375 w x 667 h Portrait classImageWidth: $classImageWidth');
        return classImageWidth;
      } else if ((orientation == Orientation.landscape) &&
          (width >= 667 && height <= 375) &&
          (width <= 811)) {
        classImageWidth = width * 0.085;
        debugPrint('375 w x 667 h Landscape classImageWidth: $classImageWidth');
        return classImageWidth;
      }
      // iPhones: 375 w x 812 h
      if ((orientation == Orientation.portrait) && (width >= 375 && height <= 812)) {
        classImageWidth = width * 0.21;
        debugPrint('375 w x 812 h Portrait classImageWidth: $classImageWidth');
        return classImageWidth;
      } else if ((orientation == Orientation.landscape) && (width >= 812 && height <= 375)) {
        classImageWidth = width * 0.07;
        debugPrint('375 w x 812 h Landscape classImageWidth: $classImageWidth');
        return classImageWidth;
      }
      // iPhones: 390 w to 430 w x 844 h to 932 h
      if ((orientation == Orientation.portrait) &&
          ((width >= 390 && width <= 430) && (height >= 844 && height <= 932))) {
        classImageWidth = width * 0.20;
        debugPrint('390 w x 932 h Portrait classImageWidth: $classImageWidth');
        return classImageWidth;
      } else if ((orientation == Orientation.landscape) && (width >= 844 && height <= 430)) {
        classImageWidth = width * 0.07;
        debugPrint('390 w x 932 h Landscape classImageWidth: $classImageWidth');
        return classImageWidth;
      }
      // iPads: 744 w to 834 w x 1024 h to 1194 h
      if ((orientation == Orientation.portrait) &&
          ((width >= 744 && width <= 834) && (height >= 1024 && height <= 1194))) {
        classImageWidth = width * 0.20;
        debugPrint(
            'iPads: 744 w to 834 w x 1024 h to 1194 h Portrait classImageWidth: $classImageWidth');
        return classImageHeight;
      } else if ((orientation == Orientation.landscape) &&
          ((height >= 744 && height <= 834) && (width >= 1024 && width <= 1194))) {
        classImageWidth = width * 0.07;
        debugPrint(
            'iPads: 744 w to 834 w x 1024 h to 1194 h Landscape classImageWidth: $classImageWidth');
        return classImageWidth;
      }
    }

    return classImageWidth;
  }

  double selectElevatedButtonHeight() {
    if (Platform.isIOS) {
      if (orientation == Orientation.portrait) {
        elevatedButtonHeight = height / 9.0;
        return elevatedButtonHeight;
      } else if (orientation == Orientation.landscape) {
        elevatedButtonHeight = height / 6.6;
        return elevatedButtonHeight;
      }
    }
    return elevatedButtonHeight;
  }

  double selectElevatedButtonWidth() {
    if (Platform.isIOS) {
      if (orientation == Orientation.portrait) {
        elevatedButtonWidth = width * 0.95;
        return elevatedButtonWidth;
      } else if (orientation == Orientation.landscape) {
        elevatedButtonWidth = width * 0.60;
        return elevatedButtonWidth;
      }
    }

    return elevatedButtonWidth;
  }

  void selectPlatformType() {
    if (Platform.isAndroid) {
      // debugPrint('Running on Android');
    } else if (Platform.isIOS) {
      // debugPrint('Running on iOS');
      if ((orientation == Orientation.portrait) && (width >= 744 && width <= 833)) {
      } else if ((orientation == Orientation.portrait) && (width >= 834 && width <= 1024)) {
      } else if ((orientation == Orientation.landscape) && (width >= 1024 && width <= 1079)) {
      } else if ((orientation == Orientation.landscape) && (width >= 1133 && height <= 744)) {
      } else if ((orientation == Orientation.landscape) && (width >= 1080 && width <= 1366)) {
      } else if ((orientation == Orientation.portrait) && (width >= 375 && height <= 667)) {
      } else if ((orientation == Orientation.landscape) && (width >= 667 && height <= 375)) {
      } else if ((orientation == Orientation.portrait) && (width >= 375 && width <= 430)) {
      } else if ((orientation == Orientation.landscape) && (width >= 480 && width <= 932)) {}
    } else if (Platform.isWindows) {
      debugPrint('Running on Windows');
    } else if (Platform.isLinux) {
      debugPrint('Running on Linux');
    } else if (Platform.isMacOS) {
      debugPrint('Running on macOS');
    } else {
      debugPrint('Running on an unknown platform');
    }
  }

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
    // Define regular expressions to check for numeric and alpha characters
    RegExp numericRegExp = RegExp(r'\d');
    RegExp alphaRegExp = RegExp(r'[a-zA-Z]');
    // bool containsNumeric = numericRegExp.hasMatch(mic);
    // bool containsAlpha = alphaRegExp.hasMatch(mic);
// Iterate through each character in the string
    for (int i = 0; i < mic.length; i++) {
      String character = mic[i];

      // Check if the character is numeric
      bool isNumeric = numericRegExp.hasMatch(mic[i]);
      bool micHasNumericAt0 = numericRegExp.hasMatch(mic[0]);

      bool micHasNumericAt1 = numericRegExp.hasMatch(mic[1]);

      bool micHasNumericAt2 = numericRegExp.hasMatch(mic[2]);

      // Check if the character is alpha
      bool isAlpha = alphaRegExp.hasMatch(mic[i]);

      // Handle the exception at each location
      if (micHasNumericAt1 || micHasNumericAt2) {
        setState(() {
          // _errorText = 'Invalid HIN MIC Code - Please Check';
          _decodedInfo = '';

          const snackBar = SnackBar(
            duration: Duration(seconds: 4),
            content: Text(
              'Error in MIC - first three characters of the HIN',
              style: TextStyle(fontSize: 30.0),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        return micUserDataResult;
        // Handle the exception here, for example, show an error message to the user.
      }

      if (isAlpha) {
        // Continue with the normal flow of your application.
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
      try {
        earlyHinWithMyearToInt = int.parse(earlyHinWithMyear);
      } catch (e) {
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

      String currentHinModelMonthValue = decodeMonthCurrentFormat(currentHinModelMonth);
      String currentHinYear = hin.substring(10);

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
