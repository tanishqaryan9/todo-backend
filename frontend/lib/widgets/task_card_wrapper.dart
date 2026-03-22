// lib/widgets/task_card_wrapper.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import 'task_card.dart';
import 'add_edit_task_sheet.dart';

class TaskCardWrapper extends StatelessWidget {
  final Task task;
  final bool showDeleteOnly;

  const TaskCardWrapper({
    super.key,
    required this.task,
    this.showDeleteOnly = false,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete Task'),
        content: Text('Delete "${task.task}"?'),
        actions: [
          CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(ctx, false)),
          CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final success = await context.read<TaskProvider>().deleteTask(task);
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.read<TaskProvider>().errorMessage ?? 'Failed to delete'),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ));
        context.read<TaskProvider>().clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskCard(
      task: task,
      showDeleteOnly: showDeleteOnly,
      onToggleComplete: () => context.read<TaskProvider>().toggleComplete(task),
      onEdit: () => AddEditTaskSheet.show(context, task: task),
      onDelete: () => _confirmDelete(context),
    );
  }
}
