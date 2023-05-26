/// Input Validation
class Validators {
  /// Takes the email string
  /// Returns if email has a valid format or not
  static bool isEmailFormatValid(String? email) {
    if (email == null) return true;
    if (email.isEmpty) return false;
    RegExp regex = RegExp(r'^.+(\..+)*@[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+$');
    return regex.hasMatch(email);
  }

  /// Takes the password
  /// Returns whether it has more than 5 characters ot not
  static bool isPasswordValid(String? password) {
    if (password == null) return true;
    if (password.isEmpty) return false;
    if (password.length < 6) return false;
    return true;
  }

  /// Takes the password and confirm password
  /// Returns whether they match or not
  static bool isConfirmPasswordValid(
      String? password, String? confirmPassword) {
    if (password == null && confirmPassword == null) return true;
    return (password == confirmPassword);
  }
}
