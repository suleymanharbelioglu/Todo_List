import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/data/data_storage.dart';
import 'package:to_do_list/main.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/widgets/task_list_item.dart';

class CustomSearchDelgate extends SearchDelegate {
  final List<Task> allTask;
  CustomSearchDelgate({required this.allTask});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = "";
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredList = allTask
        .where(
          (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var _oAnkiListeElemani = filteredList[index];
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
                  filteredList.removeAt(index);
                  await locator<LocalStorage>()
                      .deleteTask(task: _oAnkiListeElemani);
                },
                child: TaskItem(task: _oAnkiListeElemani),
              );
            },
          )
        : Center(
            child: Text("search_not_found").tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
