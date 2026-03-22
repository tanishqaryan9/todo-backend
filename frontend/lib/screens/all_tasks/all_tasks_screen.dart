// lib/screens/all_tasks/all_tasks_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/task_card_wrapper.dart';
import '../../widgets/add_edit_task_sheet.dart';
import '../../widgets/creator_profile_sheet.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final tasks = provider.allTasks;

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                backgroundColor: AppTheme.background,
                title: const Text('All Tasks'),
                leading: IconButton(
                  tooltip: 'About Developer',
                  icon: const Icon(
                    Icons.menu,
                    color: AppTheme.textPrimary,
                  ),
                  onPressed: () => CreatorProfileSheet.show(context),
                ),
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
                SliverToBoxAdapter(child: _StatsRow(provider: provider)),
              if (provider.isLoading && tasks.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CupertinoActivityIndicator()),
                )
              else if (tasks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(
                          bottom: index == tasks.length - 1 ? AppSpacing.lg : 0),
                      child: TaskCardWrapper(
                          task: tasks[index],
                          showDeleteOnly: tasks[index].isCompleted),
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

class _EmptyState extends StatelessWidget {
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
                color: AppTheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(CupertinoIcons.checkmark_circle,
                  size: 40, color: AppTheme.primary.withOpacity(0.6)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('No Tasks Yet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text('Tap + to add your first task.',
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
                textStyle: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final TaskProvider provider;
  const _StatsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.sm),
      child: Row(
        children: [
          _StatChip(
              label: 'Pending',
              value: provider.pendingTasks.length,
              color: AppTheme.warning),
          const SizedBox(width: AppSpacing.sm),
          _StatChip(
              label: 'Done',
              value: provider.completedTasks.length,
              color: AppTheme.success),
          const SizedBox(width: AppSpacing.sm),
          if (provider.pendingTasks.any((t) => t.isOverdue))
            _StatChip(
              label: 'Overdue',
              value: provider.pendingTasks.where((t) => t.isOverdue).length,
              color: AppTheme.danger,
            ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$value',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  fontSize: 13)),
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