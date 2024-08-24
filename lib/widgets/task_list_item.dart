import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/data/data_storage.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/models/task_model.dart';

// ignore: must_be_immutable
class TaskItem extends StatefulWidget {
  Task task;
  TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updataTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              color: widget.task.isCompleted ? Colors.green : Colors.white,
              border: Border.all(color: Colors.grey, width: 0.8),
              shape: BoxShape.circle,
            ),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              )
            : TextField(
                // autofocus: true,
                textInputAction: TextInputAction.done,
                minLines: 1,
                maxLines: null,
                controller: _taskNameController,
                decoration: InputDecoration(border: InputBorder.none),
                onSubmitted: (yeniDeger) {
                  if (yeniDeger.length > 3) {
                    widget.task.name = yeniDeger;
                    _localStorage.updataTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat("hh:mm a").format(widget.task.createdAt),
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
