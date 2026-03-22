// lib/screens/pending_tasks/pending_tasks_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/task_card_wrapper.dart';
import '../../widgets/add_edit_task_sheet.dart';

class PendingTasksScreen extends StatelessWidget {
  const PendingTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final tasks = provider.pendingTasks;
        final overdueCount = tasks.where((t) => t.isOverdue).length;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                backgroundColor: AppTheme.background,
                title: const Text('Pending'),
                actions: [
                  _SortButton(provider: provider),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                          color: AppTheme.primary, shape: BoxShape.circle),
                      child: const Icon(CupertinoIcons.add,
                          color: Colors.white, size: 18),
                    ),
                    onPressed: () => AddEditTaskSheet.show(context),
                  ),
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
                        _Chip(icon: CupertinoIcons.clock, label: '${tasks.length} pending', color: AppTheme.warning),
                        if (overdueCount > 0) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _Chip(icon: CupertinoIcons.exclamationmark_circle_fill, label: '$overdueCount overdue', color: AppTheme.danger),
                        ],
                      ],
                    ),
                  ),
                ),
              if (tasks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _AllCaughtUp(),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(
                          bottom: index == tasks.length - 1 ? AppSpacing.lg : 0),
                      child: TaskCardWrapper(task: tasks[index]),
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

class _AllCaughtUp extends StatelessWidget {
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
              child: Icon(CupertinoIcons.sparkles,
                  size: 40, color: AppTheme.success.withOpacity(0.7)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('All Caught Up!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text('No pending tasks. Great work!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () => AddEditTaskSheet.show(context),
              icon: const Icon(CupertinoIcons.add, size: 18),
              label: const Text('Add a Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
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
