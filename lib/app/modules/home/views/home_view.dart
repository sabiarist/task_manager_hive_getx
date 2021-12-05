import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:task_manager_hive_getx/app/modules/home/widgets/task_widget.dart';
import 'package:task_manager_hive_getx/app/shared/models/task.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager_hive_getx/main.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTasks(),
      builder: (context, Box<Task> box, Widget? child){
        var tasks = box.values.toList();
        tasks.sort((a,b) => a.createdAt.compareTo(b.createdAt));
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: false,
            title: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                margin: const EdgeInsets.only(left: 6),
                child: const Text(
                  'What\'s up for Today?',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListTile(
                              title: TextField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter task name'),
                                onSubmitted: (value) {
                                  Navigator.pop(context);
                                },
                                autofocus: true,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  print('click click');
                                  Navigator.pop(context);
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now(),
                                      maxTime: DateTime(2019, 6, 7),
                                      onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (date) {
                                        print('confirm $date');
                                      }, currentTime: DateTime.now());
                                },
                                icon: const Icon(Icons.alarm),
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          body: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              var task = tasks[index];
              return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.delete_outline,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('This task was deleted',
                          style: TextStyle(
                            color: Colors.grey,
                          ))
                    ],
                  ),
                  onDismissed: (direction) {
                    print('hey');
                  },
                  key: Key(task.id),
                  child: TaskWidget(task: tasks[index]));
            },
          ),
        );
      },
    );
  }
}
