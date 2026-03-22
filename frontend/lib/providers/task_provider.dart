// lib/providers/task_provider.dart

import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

enum SortMode { none, byDueDate }

enum LoadingState { idle, loading, success, error }

class TaskProvider extends ChangeNotifier {
  final TaskApiService _apiService;

  TaskProvider({TaskApiService? apiService})
      : _apiService = apiService ?? TaskApiService();

  List<Task> _allTasks = [];
  LoadingState _loadingState = LoadingState.idle;
  String? _errorMessage;
  SortMode _sortMode = SortMode.none;

  List<Task> get allTasks => _sortMode == SortMode.byDueDate
      ? _sortedByDueDate(_allTasks)
      : _allTasks;

  List<Task> get completedTasks {
    final filtered = _allTasks.where((t) => t.isCompleted).toList();
    return _sortMode == SortMode.byDueDate ? _sortedByDueDate(filtered) : filtered;
  }

  List<Task> get pendingTasks {
    final filtered = _allTasks.where((t) => !t.isCompleted).toList();
    return _sortMode == SortMode.byDueDate ? _sortedByDueDate(filtered) : filtered;
  }

  LoadingState get loadingState => _loadingState;
  String? get errorMessage => _errorMessage;
  SortMode get sortMode => _sortMode;
  bool get isEmpty => _allTasks.isEmpty;
  bool get isLoading => _loadingState == LoadingState.loading;

  List<Task> _sortedByDueDate(List<Task> tasks) {
    final withDate = tasks.where((t) => t.dueDate != null).toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    final withoutDate = tasks.where((t) => t.dueDate == null).toList();
    return [...withDate, ...withoutDate];
  }

  void toggleSortMode() {
    _sortMode =
        _sortMode == SortMode.none ? SortMode.byDueDate : SortMode.none;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    debugPrint('>>> loadTasks() called');
    _setLoading();
    try {
      debugPrint('>>> calling _apiService.getAllTasks()');
      _allTasks = await _apiService.getAllTasks();
      debugPrint('>>> got ${_allTasks.length} tasks');
      _loadingState = LoadingState.success;
      _errorMessage = null;
    } catch (e, stack) {
      debugPrint('>>> loadTasks ERROR: $e');
      debugPrint('>>> STACK: $stack');
      _loadingState = LoadingState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> addTask(Task task) async {
    try {
      debugPrint('>>> addTask() called: ${task.task}');
      final newTask = await _apiService.addTask(task);
      debugPrint('>>> addTask success: ${newTask.id}');
      _allTasks.add(newTask);
      notifyListeners();
      return true;
    } catch (e, stack) {
      debugPrint('>>> addTask ERROR: $e');
      debugPrint('>>> STACK: $stack');
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleComplete(Task task) async {
    try {
      final updated = await _apiService.patchTask(
        task.task,
        {'isCompleted': !task.isCompleted},
      );
      final idx = _allTasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) {
        _allTasks[idx] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('>>> toggleComplete ERROR: $e');
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(String originalName, Task task) async {
    try {
      final updated = await _apiService.updateTask(originalName, task);
      final idx = _allTasks.indexWhere((t) => t.task == originalName);
      if (idx != -1) {
        _allTasks[idx] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('>>> updateTask ERROR: $e');
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(Task task) async {
    try {
      if (task.id != null) {
        await _apiService.deleteTaskById(task.id!);
      } else {
        await _apiService.deleteTaskByName(task.task);
      }
      _allTasks.removeWhere((t) => t.id == task.id);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('>>> deleteTask ERROR: $e');
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading() {
    _loadingState = LoadingState.loading;
    notifyListeners();
  }
}
