class Validators {
  static String? email(String? val) {
    if (val!.isEmpty) return "Email cannot be empty!";
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(val)) return "Invalid Email";
    return null;
  }

  static String? password(String? val) {
    if (val!.isEmpty) return "Password cannot be empty!";
    if (val.length < 8 || val.length > 32) {
      return "Password must be between length 8 and 32";
    }
    return null;
  }

  static String? username(String? val) {
    if (val!.isEmpty) return "Username cannot be empty!";
    if (val.length < 6 || val.length > 32) {
      return "Username length must be between 6 and 32.";
    }
    return null;
  }
}
