import 'package:flutter/material.dart';

extension() {}

extension TimeOfDayExtension on TimeOfDay {
  String get toStringAsTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
