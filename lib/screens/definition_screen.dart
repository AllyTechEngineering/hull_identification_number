import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utilities/responsive_adaptive_class.dart';
// import 'package:hull_identification_number/blocs/data/mic_data_cubit.dart';
// import 'package:hull_identification_number/models/mic_data_model.dart';
// import 'package:hull_identification_number/repositories/mic_repository.dart';
// import 'package:hull_identification_number/screens/home_screen_two.dart';

class DefinitionScreen extends StatefulWidget {
  const DefinitionScreen({super.key});

  @override
  State<DefinitionScreen> createState() => _DefinitionScreenState();
}

class _DefinitionScreenState extends State<DefinitionScreen> {
  ResponsiveAdaptiveClass responsiveAdaptiveClass = ResponsiveAdaptiveClass();

  @override
  Widget build(BuildContext context) {
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
            'FAQ',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () => context.go('/settings_screen'),
          ),
        ],
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text:
                                'History: Prior to Nov. 1,1972 there were no requirements for a HIN to be assigned to recreational boats.  Manufacturers used mostly serial numbers that were unique to that manufacturer, but had no prescribed format beyond that specific manufacturer. Nov. 1,1972 The U.S. Coast Guard required all manufacturers to affix a 12 character HIN on all domestic and imported recreational boats per 33 CFR §181.\nHere are the three formats you may find on a boat',
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          'assets/images/Straight-Format.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Divider(
                        thickness: 2.0,
                      ),
                      Container(
                        child: Image.asset(
                          'assets/images/Model-Year-Format.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Divider(
                        thickness: 2.0,
                      ),
                      Container(
                        child: Image.asset(
                          'assets/images/Current-Format.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // child: ElevatedButton(
          //   onPressed: () => context.go('/'),
          //   child: const Text('Go back to the Home screen'),
          // ),
        ),
      ),
    );
  }
}
