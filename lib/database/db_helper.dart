import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_management_app/models/project.dart';

import '../models/task.dart';

class DbHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return await _database!;
    } else {
      _database = await _initDb();
      return await _database!;
    }
  }

  static Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'task management.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
     CREATE TABLE projects(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       title TEXT NOT NULL,
       description TEXT NOT NULL,
       deadline TEXT NOT NULL,
       status TEXT NOT NULL DEFAULT 'active'
       )
       ''');
    await db.execute('''
      CREATE TABLE tasks(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       project_id INTEGER NOT NULL,
       title TEXT NOT NULL,
       priority TEXT NOT NULL
       deadline TEXT NOT NULL,
       isCompleted INTEGER NOT NULL DEFAULT 0,
       FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
      )
      ''');
  }

  // Project CRUD
  static Future<int> insertProject(Project project) async {
    final db = await database;
    return db.insert('projects', project.toMap());
  }

  static Future<List<Project>> getAllProjects() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'projects',
      orderBy: 'id DESC',
    );
    return maps.map((map) => Project.fromMap(map)).toList();
  }

  static Future<int> updateProject(Project project) async {
    final db = await database;
    return db.update(
      'projects',
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  static Future<int> deleteProject(int id) async {
    final db = await database;
    return db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }

  // Task CRUD

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasksByProject(int projectId) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'id DESC',
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> toggleTask(int id, int currentStatus) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'isCompleted': currentStatus == 0 ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}