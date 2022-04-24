class Validaciones {
  static final _emailRE = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool emailValido(String email) {
    return _emailRE.hasMatch(email);
  }
}
