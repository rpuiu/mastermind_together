class FormValidators {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 3) {
      return 'Username should be at least 3 characters long';
    }
    if (value.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
      return 'Username should not contain special characters or numbers';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password should be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password should contain at least one number';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password should contain at least one uppercase letter';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != password) {
      return 'Password does not match';
    }
    return null;
  }

  static String? validateGoal(String? value) {
    if (value == null || value.trim() == '') {
      return 'Please enter your goal';
    } else if (value.length > 100) {
      return 'The goal cannot exceed 100 characters';
    }
    return null;
  }
}
