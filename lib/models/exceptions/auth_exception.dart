import 'package:survey/models/exceptions/base_exception.dart';

abstract class AuthException implements BaseException {
  static AuthException get emailAlreadyInUse => EmailAlreadyInUseException();

  static AuthException get usernameAlreadyInUse => UsernameAlreadyInUseException();

  static AuthException get weakPassword => WeakPasswordException();

  static AuthException get userNotFound => UserNotFoundException();

  static AuthException get wrongPassword => WrongPasswordException();

  static AuthException get tooManyRequests => TooManyRequestsException();
}

class EmailAlreadyInUseException implements AuthException {
  const EmailAlreadyInUseException._();

  factory EmailAlreadyInUseException() => const EmailAlreadyInUseException._();

  @override
  String get errorMessage => "E-posta adresine kayıtlı bir hesap bulunmakta!";
}

class UsernameAlreadyInUseException implements AuthException {
  const UsernameAlreadyInUseException._();

  factory UsernameAlreadyInUseException() => const UsernameAlreadyInUseException._();

  @override
  String get errorMessage => "Kullanıcı adına kayıtlı bir hesap bulunmakta!";
}

class WeakPasswordException implements AuthException {
  const WeakPasswordException._();

  factory WeakPasswordException() => const WeakPasswordException._();

  @override
  String get errorMessage => "Şifre çok zayıf!";
}

class UserNotFoundException implements AuthException {
  const UserNotFoundException._();

  factory UserNotFoundException() => const UserNotFoundException._();

  @override
  String get errorMessage => "Kullanıcı bulunamadı!";
}

class WrongPasswordException implements AuthException {
  const WrongPasswordException._();

  factory WrongPasswordException() => const WrongPasswordException._();

  @override
  String get errorMessage => "Hatalı şifre!";
}

class TooManyRequestsException implements AuthException {
  const TooManyRequestsException._();

  factory TooManyRequestsException() => const TooManyRequestsException._();

  @override
  String get errorMessage => "Bu hesaba çok sayıda istek yapıldı!";
}
