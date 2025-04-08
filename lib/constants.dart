const double padding = 20;
const double borderRadius = 10;
const double roundRadius = 30;
const double borderInputRadius = 10;

class Collections {
  final String notifications = 'notifications';
  final String tasks = 'tasks';
}

final collections = Collections();

enum TaskStatus { pending, inProgress, completed, cancelled }

enum TaskPriority { low, medium, high }
