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

String greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning 👋';
  } else if (hour < 17) {
    return 'Good Afternoon 👋';
  } else {
    return 'Good Evening 👋';
  }
}

String formatDateTime(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCheck = DateTime(date.year, date.month, date.day);

  final hour = date.hour;
  final minute = date.minute.toString().padLeft(2, '0');
  final period = hour >= 12 ? 'PM' : 'AM';
  final hour12 =
      (hour > 12
              ? hour - 12
              : hour == 0
              ? 12
              : hour)
          .toString();

  if (dateToCheck == today) {
    return 'Today $hour12:$minute $period';
  } else if (dateToCheck == yesterday) {
    return 'Yesterday $hour12:$minute $period';
  } else if (now.difference(date).inDays < 7) {
    return '${getWeekday(date.weekday)} $hour12:$minute $period';
  } else {
    return '${date.day} ${getMonthName(date.month)} ${date.year} $hour12:$minute $period';
  }
}

String getWeekday(int weekday) {
  switch (weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return '';
  }
}

String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}
