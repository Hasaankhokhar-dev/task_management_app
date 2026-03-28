import 'package:flutter/material.dart';
import 'package:task_management_app/database/db_helper.dart';
import '../models/project.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  String _searchQuery = '';
  List<Project> get projects {
    if (_searchQuery.isEmpty) {
      return _projects;
    } else {
      return _projects
          .where(
            (p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
  }

  String get searchQuery => _searchQuery;

  Future<void> loadProjects() async {
    _projects = await DbHelper.getAllProjects();
    notifyListeners();
  }

  Future<void> addProject(Project project) async {
    await DbHelper.insertProject(project);
    await loadProjects();
  }

  Future<void> updateProject(Project project) async {
    await DbHelper.updateProject(project);
    await loadProjects();
  }

  Future<void> deleteProject(int id) async {
    await DbHelper.deleteProject(id);
    await loadProjects();
  }

  void searchProjects(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
