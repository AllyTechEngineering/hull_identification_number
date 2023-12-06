import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hull_identification_number/blocs/data/data_cubit.dart';
import 'package:hull_identification_number/models/mic_data_model.dart';
import 'package:hull_identification_number/repositories/mic_repository.dart';
import 'package:hull_identification_number/screens/home_screen_two.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/responsive_adaptive_class.dart';
import '../utilities/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ResponsiveAdaptiveClass responsiveAdaptiveClass = ResponsiveAdaptiveClass();
  late final UrlLauncher urlLauncher;
  @override
  Widget build(BuildContext context) {
    responsiveAdaptiveClass.orientation = MediaQuery.of(context).orientation;
    responsiveAdaptiveClass.size = MediaQuery.of(context).size;
    responsiveAdaptiveClass.height = responsiveAdaptiveClass.size.height;
    responsiveAdaptiveClass.width = responsiveAdaptiveClass.size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left_outlined,
          ),
          onPressed: () => context.go('/'),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'About the Developer',
            style: TextStyle(
                fontSize: responsiveAdaptiveClass.appBarTitleFontSize =
                    responsiveAdaptiveClass.selectAppBarTitleFontSize()),
          ),
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
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 1.0,
              image: AssetImage('assets/images/ocean_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
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
                        _launchURLBrowser('https://www.linkedin.com/in/bob-taylor-mscs-mba/');
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
                        'Bob Taylor LinkedIn',
                        style: TextStyle(
                            fontSize: responsiveAdaptiveClass.classFontSize =
                                responsiveAdaptiveClass.selectClassFontSize(),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
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
                        _launchURLBrowser('https://github.com/AllyTechEngineering/');
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
                        'Bob Taylor Portfolio',
                        style: TextStyle(
                            fontSize: responsiveAdaptiveClass.classFontSize =
                                responsiveAdaptiveClass.selectClassFontSize(),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
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
                        _launchURLBrowser('https://allytechllc.com/privacy');
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
                        'Privacy',
                        style: TextStyle(
                            fontSize: responsiveAdaptiveClass.classFontSize =
                                responsiveAdaptiveClass.selectClassFontSize(),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            // child: ElevatedButton(
            //   onPressed: () => context.go('/'),
            //   child: const Text('Go back to the Home screen'),
            // ),
          ),
        ),
      ),
    );
  }

  _launchURLBrowser(String urlValue) async {
    var url = Uri.parse(urlValue);
    if (await canLaunchUrl(url)) {
      print('Inside of if means canLaunchUrl ok');
      await launchUrl(url);
    } else {
      print('After the else means an error: $url');
      throw 'Could not launch $url';
    } //else
  } //_launchURLBrowser
}
