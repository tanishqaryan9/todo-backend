// lib/screens/completed_tasks/completed_tasks_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/task_card_wrapper.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({super.key});

  Future<void> _clearAll(BuildContext context, TaskProvider provider) async {
    final tasks = provider.completedTasks;
    if (tasks.isEmpty) return;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Clear All Completed'),
        content: Text('Delete all ${tasks.length} completed task${tasks.length == 1 ? '' : 's'}?'),
        actions: [
          CupertinoDialogAction(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx, false)),
          CupertinoDialogAction(isDestructiveAction: true, child: const Text('Delete All'), onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      for (final task in List.from(tasks)) {
        await provider.deleteTask(task);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('All completed tasks deleted'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final tasks = provider.completedTasks;
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                backgroundColor: AppTheme.background,
                title: const Text('Completed'),
                actions: [
                  _SortButton(provider: provider),
                  if (tasks.isNotEmpty) ...[
                    const SizedBox(width: AppSpacing.xs),
                    IconButton(
                      tooltip: 'Clear all',
                      icon: const Icon(CupertinoIcons.trash, color: AppTheme.danger),
                      onPressed: () => _clearAll(context, provider),
                    ),
                  ],
                  const SizedBox(width: AppSpacing.xs),
                ],
              ),
              if (tasks.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.sm),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(CupertinoIcons.checkmark_circle_fill,
                                  color: AppTheme.success, size: 14),
                              const SizedBox(width: 5),
                              Text('${tasks.length} completed',
                                  style: const TextStyle(
                                      color: AppTheme.success,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => _clearAll(context, provider),
                          child: const Text('Clear All',
                              style: TextStyle(
                                  color: AppTheme.danger,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                    ),
                  ),
                ),
              if (tasks.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyCompleted(),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(
                          bottom: index == tasks.length - 1 ? AppSpacing.lg : 0),
                      // showDeleteOnly=true → swipe right to delete, no edit, strikethrough
                      child: TaskCardWrapper(task: tasks[index], showDeleteOnly: true),
                    ),
                    childCount: tasks.length,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyCompleted extends StatelessWidget {
  const _EmptyCompleted();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(CupertinoIcons.checkmark_seal,
                  size: 40, color: AppTheme.success.withOpacity(0.7)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Nothing Completed Yet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text('Completed tasks will appear here.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final TaskProvider provider;
  const _SortButton({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isActive = provider.sortMode == SortMode.byDueDate;
    return IconButton(
      tooltip: isActive ? 'Remove sort' : 'Sort by due date',
      icon: Icon(CupertinoIcons.sort_down,
          color: isActive ? AppTheme.primary : AppTheme.textSecondary),
      onPressed: provider.toggleSortMode,
    );
  }
}
