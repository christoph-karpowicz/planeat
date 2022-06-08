import 'package:flutter/material.dart';

ThemeData getThemeData() {
  return ThemeData.light().copyWith(
    timePickerTheme: TimePickerThemeData(
      hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? Colors.green
          : Colors.grey.shade700),
      hourMinuteColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? Colors.green.withOpacity(0.1)
          : Colors.grey.shade700.withOpacity(0.1)),
      dialHandColor: Colors.green,
      dialBackgroundColor: Colors.grey[100],
      dialTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? Colors.white
          : Colors.black),
      dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? Colors.green
          : Colors.grey),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateColor.resolveWith((states) => Colors.green),
        )),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.green,
      selectionColor: Colors.green,
      selectionHandleColor: Colors.green,
    ),
  );
}
