class Validator {
  static String? name(String? name) {
    if (name == null || name.isEmpty) {
      return 'Por favor, digite seu nome';
    }
    if (!name.contains(" ") || name.length < 8) {
      return 'Por favor, digite um nome e sobrenome';
    }
    return null;
  }

  static String? phone(String? phone) {
    RegExp regExp =
        RegExp(r'(^(?:\+|00)?\d{1,3}\s?)?(?:\(?\d{2,3}\)?[\s.-]?)?\d{4,5}[\s.-]?\d{4}$');

    if (phone == null || phone.isEmpty) {
      return 'Por favor, digite seu número de telefone';
    }

    if (!regExp.hasMatch(phone)) {
      return 'Por favor, digite um número de telefone valido';
    }

    return null;
  }

  static String? email(String? email) {
    if (email == null || email.isEmpty) {
      return 'Por favor, digite seu email';
    }
    if (!email.contains("@") || !email.contains('.')) {
      return 'Por favor, digite um email válido';
    }
    return null;
  }

  static String? password(String? password) {
    /*
    * r'^
      (?=.*[A-Z])       // should contain at least one upper case
      (?=.*[a-z])       // should contain at least one lower case
      (?=.*?[0-9])      // should contain at least one digit
      (?=.*?[!@#\$&*~]) // should contain at least one Special character
      .{8,}             // Must be at least 8 characters in length
      $
      * RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    * */

    RegExp regex = RegExp(r'^(?=.*?[0-9]).{8,}$');

    if (password == null || password.isEmpty) {
      return 'Por favor, digite sua senha';
    }
    if (!regex.hasMatch(password)) {
      return 'sua senha deve conter letras, numeros e minimo 8 caracteres';
    }
    return null;
  }

  static String? confirmPassword(String? password1, String? password2) {
    if (password1 == null || password1.isEmpty) {
      return 'Por favor, digite sua senha';
    }
    if (password1 != password2) {
      return 'As senhas não coincidem';
    }
    return null;
  }
}
