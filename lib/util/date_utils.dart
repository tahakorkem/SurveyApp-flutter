import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String format() {
    return DateFormat('dd-MM-yyyy').format(this);
  }
}