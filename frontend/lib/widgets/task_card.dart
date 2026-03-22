// lib/widgets/task_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showDeleteOnly; // true = completed screen (only delete), false = pending (edit+complete)

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
    this.showDeleteOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 3),
      child: Slidable(
        key: ValueKey(task.id),
        // Swipe RIGHT → delete (startActionPane)
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: showDeleteOnly ? 0.28 : 0.28,
          children: [
            CustomSlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppTheme.danger,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.trash, size: 22),
                  const SizedBox(height: 4),
                  Text('Delete',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        // Swipe LEFT → edit (only on non-completed tasks)
        endActionPane: showDeleteOnly
            ? null
            : ActionPane(
                motion: const BehindMotion(),
                extentRatio: 0.28,
                children: [
                  CustomSlidableAction(
                    onPressed: (_) => onEdit(),
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.pencil, size: 22),
                        const SizedBox(height: 4),
                        Text('Edit',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
        child: _TaskCardContent(
          task: task,
          onToggleComplete: onToggleComplete,
          showDeleteOnly: showDeleteOnly,
        ),
      ),
    );
  }
}

class _TaskCardContent extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final bool showDeleteOnly;

  const _TaskCardContent({
    required this.task,
    required this.onToggleComplete,
    required this.showDeleteOnly,
  });

  Color get _dueDateColor {
    if (task.isCompleted) return AppTheme.textTertiary;
    if (task.isOverdue) return AppTheme.danger;
    if (task.isDueToday) return AppTheme.warning;
    return AppTheme.primary.withOpacity(0.7);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: showDeleteOnly ? null : onToggleComplete,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circle checkbox (only on pending tasks)
              if (!showDeleteOnly)
                GestureDetector(
                  onTap: onToggleComplete,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: AppTheme.textTertiary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              // Completed checkmark badge
              if (showDeleteOnly)
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.success,
                  ),
                  child: const Icon(Icons.check, size: 15, color: Colors.white),
                ),
              const SizedBox(width: AppSpacing.md),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.task,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            decoration: showDeleteOnly
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: AppTheme.textTertiary,
                            color: showDeleteOnly
                                ? AppTheme.textTertiary
                                : AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (task.description != null && task.description!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                    // Always show due date row
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          task.isOverdue && !showDeleteOnly
                              ? CupertinoIcons.exclamationmark_circle_fill
                              : CupertinoIcons.calendar,
                          size: 13,
                          color: task.dueDate != null ? _dueDateColor : AppTheme.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.dueDate != null
                              ? (task.isDueToday && !showDeleteOnly
                                  ? 'Due Today'
                                  : task.isOverdue && !showDeleteOnly
                                      ? 'Overdue · ${DateFormat('MMM d').format(task.dueDate!)}'
                                      : DateFormat('MMM d, yyyy').format(task.dueDate!))
                              : 'No due date',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: task.dueDate != null
                                    ? _dueDateColor
                                    : AppTheme.textTertiary,
                                fontWeight: task.isOverdue && !showDeleteOnly
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Hint icon
              Icon(
                showDeleteOnly
                    ? CupertinoIcons.arrow_left
                    : CupertinoIcons.arrow_right,
                size: 13,
                color: AppTheme.textTertiary.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
