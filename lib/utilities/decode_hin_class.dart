// import 'package:flutter/material.dart';
// import 'package:hull_identification_number/screens/home_screen_two.dart';

class DecodeHinClass {
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

  String decodeStraightYearFormat(String code) {
    switch (code.toUpperCase()) {
      case '01':
        return 'January';
      case '02':
        return 'February';
      case '03':
        return 'March';
      case '04':
        return 'April';
      case '05':
        return 'May';
      case '06':
        return 'June';
      case '07':
        return 'July';
      case '08':
        return 'August';
      case '09':
        return 'September';
      case '10':
        return 'October';
      case '11':
        return 'November';
      case '12':
        return 'December';
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
