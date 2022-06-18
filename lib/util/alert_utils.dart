import 'package:flutter/cupertino.dart';
import 'package:survey/models/exceptions/base_exception.dart';
import 'package:survey/models/result.dart';
import 'snackbar_utils.dart';

extension AlertExtension on BuildContext {
  void alertError(Result error) {
    final exception = (error as Error).exception;
    final errorMessage = exception is BaseException
        ? exception.errorMessage
        : "Bir hata ile karşılaşıldı.";//exception.toString();
    snackbar(errorMessage);
  }
}