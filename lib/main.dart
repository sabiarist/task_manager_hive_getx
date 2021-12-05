import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager_hive_getx/app/data/hive_data_store.dart';
import 'package:task_manager_hive_getx/app/shared/models/task.dart';
import 'app/modules/home/views/home_view.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  var box = await Hive.openBox<Task>('tasks');

  box.values.forEach((task) {
    if(task.createdAt.day != DateTime.now().day){
      box.delete(task.id);
    }
  });
  runApp(const MyApp());
}

class   BaseWidget extends InheritedWidget{
  BaseWidget({Key? key, required this.child}) : super(key: key, child: child );

  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;


  static BaseWidget of(BuildContext context){
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null){
      return base;
    }else{
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(BaseWidget oldWidget) {
    //return dataStore != oldWidget.dataStore;
    return false;
  }
  
  

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
            elevation: 0.0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            )),
      ),
      initialRoute: 'homeview',
      routes: {
        'homeview': (context) => HomeView(),
      },
    );
  }
}
