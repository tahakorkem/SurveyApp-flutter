import 'package:flutter/widgets.dart';

extension ContextExtension on BuildContext {
  double width([double percentage = 1]) => MediaQuery.of(this).size.width * percentage;
  double height([double percentage = 1]) => MediaQuery.of(this).size.height * percentage;
}
