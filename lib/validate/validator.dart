class Validator {
  static const MIN_USERNAME_LENGTH = 3;
  static const MAX_USERNAME_LENGTH = 15;

  static const MIN_PASSWORD_LENGTH = 8;
  static const MAX_PASSWORD_LENGTH = 20;

  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty)
      return "Kullanıcı adı boş bırakılamaz!";
    username = username.trim();
    if (username.length < MIN_USERNAME_LENGTH)
      return "Kullanıcı adı en az $MIN_USERNAME_LENGTH karakter olmalıdır.";
    if (username.length > MAX_USERNAME_LENGTH)
      return "Kullanıcı adı $MAX_USERNAME_LENGTH karakterden uzun olmamalıdır.";
    if (username.contains(" ")) return "Kullanıcı adı boşluk içermemelidir!";
    final regex1 = RegExp(r"^(?=[_.]).+$");
    if (regex1.hasMatch(username))
      return "Kullanıcı adı alttan tire [_] veya nokta [.] ile başlayamaz!";
    final regex2 = RegExp(r"^[a-zA-Z0-9._]+$");
    if (!regex2.hasMatch(username))
      return "Kullanıcı adı kabul edilmeyen karakter içermekte!";
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty)
      return "E-posta adresi boş bırakılamaz!";
    email = email.trim();
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    if (!regex.hasMatch(email)) return "E-posta adresi geçerli değil!";
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return "Şifre boş bırakılamaz!";
    if (password.length < MIN_PASSWORD_LENGTH)
      return "Şifre en az $MIN_PASSWORD_LENGTH karakter olmalıdır.";
    if (password.length > MAX_PASSWORD_LENGTH)
      return "Şifre $MAX_PASSWORD_LENGTH karakterden uzun olmamalıdır.";
    final regex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[\S]+$");
    if (!regex.hasMatch(password))
      return "Şifreniz bir küçük, bir büyük karakter ve bir rakam içermeli!";
    return null;
  }

  static String? validatePasswordRepeat(
      String password, String? passwordRepeat) {
    if (passwordRepeat == null || passwordRepeat.isEmpty)
      return "Şifre boş bırakılamaz!";
    if (password != passwordRepeat) return "Şifreler eşleşmiyor!";
    return null;
  }
}
