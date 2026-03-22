// lib/models/task_model.dart

class Task {
  final int? id;
  final String task;
  final bool isCompleted;
  final DateTime? dueDate;
  final String? description;

  Task({
    this.id,
    required this.task,
    this.isCompleted = false,
    this.dueDate,
    this.description,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      task: json['task'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'task': task,
      'isCompleted': isCompleted,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String().split('T').first,
      if (description != null) 'description': description,
    };
  }

  Task copyWith({
    int? id,
    String? task,
    bool? isCompleted,
    DateTime? dueDate,
    String? description,
    bool clearDueDate = false,
  }) {
    return Task(
      id: id ?? this.id,
      task: task ?? this.task,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      description: description ?? this.description,
    );
  }

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }
}
