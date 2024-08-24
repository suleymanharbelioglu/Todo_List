import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:to_do_list/data/data_storage.dart';
import 'package:to_do_list/helper/translation_helper.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/widgets/custom_search_delgate.dart';
import 'package:to_do_list/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet(context);
          },
          child: Text(
            "title",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showAddTaskBottomSheet(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemCount: _allTasks.length,
              itemBuilder: (context, index) {
                var _oAnkiListeElemani = _allTasks[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text("remove_task").tr(),
                    ],
                  ),
                  key: Key(_oAnkiListeElemani.id),
                  onDismissed: (direction) async {
                    _allTasks.removeAt(index);
                    await _localStorage.deleteTask(task: _oAnkiListeElemani);
                    setState(() {});
                  },
                  child: TaskItem(task: _oAnkiListeElemani),
                );
              },
            )
          : Center(
              child: Text("empty_task_list").tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "add_task".tr(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                print(value);
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    locale: TranslationHelper.getDeviceLanguage(context),
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev =
                          Task.create(name: value, createdAt: time);
                      _allTasks.insert(0, yeniEklenecekGorev);
                      await _localStorage.addTask(task: yeniEklenecekGorev);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  Future<void> _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelgate(allTask: _allTasks));
    _getAllTaskFromDb();
  }
}
