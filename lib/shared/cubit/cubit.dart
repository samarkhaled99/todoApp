import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archived_screen/Archived_Screen.dart';
import 'package:todoapp/modules/done_screen/Done_Screen.dart';
import 'package:todoapp/modules/new_tasks/New_Tasks.dart';

import 'package:todoapp/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasKsScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titels = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void ChangeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        //id title date time status
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when creating table${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
      },
    ).then((value) {
      print(value);
      database = value;
      emit(AppCreateDBState());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    print('adding called');
    await database.transaction((txn) {
      print('value $txn');
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date,time,status)VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDBState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when inserting ${error.tpString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(database)  {
newTasks=[];
doneTasks=[];
archivedTasks=[];


    emit(AppGetDBLoadingState());
   database.rawQuery('SELECT * FROM tasks').then((value) {
     print(value.first);

    value.forEach((element) {
       if(element['status']== 'new')
         newTasks.add(element);
       else if(element['status']== 'done')
         doneTasks.add(element);
       else  archivedTasks.add(element);
     });
     emit(AppGetDBState());
   });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState(
      {@required bool isShow, @required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
  void UpdateData({
  @required String status,
    @required int id,
}) async{
    //int count =
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id']).then((value) {
          getDataFromDatabase(database);
      emit(AppUpdateDBState());
     }
     );
  }

  void deleteData({
    @required int id,
  }) async{
    //int count =
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [ id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDBState());
    }
    );
  }
  bool isDark =false;
  void changeAppMode(){
    isDark=! isDark;
    emit(NewsAppChangeModeState());
  }

}
