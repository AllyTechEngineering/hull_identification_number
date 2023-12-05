import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hull_identification_number/blocs/data/data_cubit.dart';
import 'package:hull_identification_number/models/mic_data_model.dart';
import 'package:hull_identification_number/repositories/mic_repository.dart';
import 'package:hull_identification_number/screens/home_screen_two.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
