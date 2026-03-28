import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  String _filterPriority = 'all';

  List<Task> get tasks {
    if (_filterPriority == 'all') {
      return _tasks;
    } else {
      return _tasks.where((t) => t.priority == _filterPriority).toList();
    }
  }

  String get filterPriority => _filterPriority;

  double get completionPercentage {
    if (_tasks.isEmpty) {
      return 0;
    }
    int done = _tasks.where((t) => t.isCompleted == 1).length;
    return done / _tasks.length;
  }

  Future<void> loadTasks(int projectId) async {
    _tasks = await DbHelper.getTasksByProject(projectId);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await DbHelper.insertTask(task);
    await loadTasks(task.projectId);
  }

  // Task update karo
  Future<void> updateTask(Task task) async {
    await DbHelper.updateTask(task);
    await loadTasks(task.projectId);
  }

  Future<void> deleteTask(int id,int projectId) async {
    await DbHelper.deleteTask(id);
    await loadTasks(projectId);
  }
  Future<void> toggleTask(int id, int currentStatus,int projectId) async{
    await DbHelper.toggleTask(id, currentStatus);
    await loadTasks(projectId);
  }
  void setFilter(String priority) {
    _filterPriority = priority;
    notifyListeners();
  }
}
