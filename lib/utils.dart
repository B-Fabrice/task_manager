String? isValidUsername(String? username) {
  if (username == null || username.isEmpty) {
    return 'Username is required';
  } else if (username.length < 4) {
    return 'Username must be at least 4 characters';
  }
  return null;
}

String? isValidEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email is required';
  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    return 'Invalid email';
  }
  return null;
}

String? isValidPassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  } else if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}
