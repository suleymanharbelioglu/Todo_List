import 'package:hive/hive.dart';
import 'package:to_do_list/models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<bool> deleteTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();

  Future<Task> updataTask({required Task task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _taskBox;
  HiveLocalStorage() {
    _taskBox = Hive.box<Task>("tasks");
  }
  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _allTasks = <Task>[];
    _allTasks = _taskBox.values.toList();
    if (_allTasks.isNotEmpty) {
      _allTasks.sort((Task a, Task b) => b.createdAt.compareTo(a.createdAt));
    }
    return _allTasks;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> updataTask({required Task task}) async {
    await task.save();
    return task;
  }
}
