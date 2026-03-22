// lib/widgets/task_list_view.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import 'task_card.dart';
import 'add_edit_task_sheet.dart';
import 'empty_state.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final bool showAddButton;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
    this.showAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return EmptyState(
        title: emptyTitle,
        subtitle: emptySubtitle,
        icon: emptyIcon,
        showAddButton: showAddButton,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          key: ValueKey(task.id),
          task: task,
          onToggleComplete: () => _toggleComplete(context, task),
          onEdit: () => AddEditTaskSheet.show(context, task: task),
          onDelete: () => _confirmDelete(context, task),
        );
      },
    );
  }

  Future<void> _toggleComplete(BuildContext context, Task task) async {
    await context.read<TaskProvider>().toggleComplete(task);
  }

  Future<void> _confirmDelete(BuildContext context, Task task) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.task}"?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context.read<TaskProvider>().deleteTask(task);
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.read<TaskProvider>().errorMessage ?? 'Failed to delete'),
            backgroundColor: AppTheme.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
        );
        context.read<TaskProvider>().clearError();
      }
    }
  }
}
