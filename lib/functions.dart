import './colors.dart';
import './widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


showSnackbar(context, text, Color? textColor, Color? backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: TextFont(
      text: text,
      fontSize: 16,
      textColor: textColor ?? Theme.of(context).colorScheme.white,
    ),
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.black 
  ));
  return;
}

extension CapExtension on String {
  /// Capitalizes the first letter of the string.
  /// Returns an empty string if the original string is empty.
  String get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  /// Converts the entire string to uppercase.
  String get allCaps => toUpperCase();

  /// Capitalizes the first letter of each word in the string.
  /// Multiple spaces between words are normalized to a single space.
  String get capitalizeFirstOfEach =>
      replaceAll(RegExp(r' +'), ' ')
          .split(" ")
          .map((str) => str.capitalizeFirst)
          .join(" ");
}

String convertToMoney(double amount) {
  const String currencyType = "₹";
  final NumberFormat currencyFormatter = NumberFormat("#,##0.00", "en_IN");

  String formattedAmount = currencyFormatter.format(amount);
  // If the formatted amount ends with ".00", remove the decimal part.
  if (formattedAmount.endsWith(".00")) {
    return currencyType + formattedAmount.substring(0, formattedAmount.length - 3);
  } else {
    // Otherwise, return the amount with its original decimal formatting.
    return currencyType + formattedAmount;
  }
}



getMonth(currentMonth) {
  var months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  return months[currentMonth];
}

getMonthShort(currentMonth) {
  var months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  return months[currentMonth];
}

getWeekDay(currentWeekDay){
  var weekDays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  return weekDays[currentWeekDay];
}

getWeekDayShort(currentWeekDay){
  var weekDays = [
    "Sun",
    "Mon",
    "Tues",
    "Wed",
    "Thurs",
    "Fri",
    "Sat"
  ];
  return weekDays[currentWeekDay];
}