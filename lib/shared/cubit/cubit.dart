import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/cubit/states.dart';
import '../../modules/archived_tasks/archived_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List <Map> archivedTasks = [];
  int currentIndex = 0;
  List<String> title = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  List<Widget> currentScreen = [NewTasksScreen(), DoneTasks(), ArchivedTasks()];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created ');
        database
            .execute('''CREATE TABLE tasks (
          id INTEGER PRIMARY KEY , title TEXT, date TEXT, time TEXT, status TEXT
          )''')
            .then((value) {
              print('table created');
            })
            .catchError((error) {
              print('Error while creating table ${error.toString()}');
            });
      },
      onOpen: (database) {
        getFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String taskTitle,
    required String taskdate,
    required String taskTime,
  }) async {
    return await database.transaction(
      (txn) => txn
          .rawInsert(
            'INSERT INTO tasks(title,date,time,status)VALUES(?,?,?,?)',
            [taskTitle, taskdate, taskTime, 'new'],
          ).then((value) {
            emit(InsertToDatabaseState());
            print('$value inserted successfully');

            getFromDatabase(database);
          })
          .catchError((error) {
            print('Error while inserting ${error.toString()}');
          }),
    );
  }

  void getFromDatabase(database)  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      print(value);
      value.forEach((element){
        if(element['status']=='new'){
          newTasks.add(element);
        }else if (element['status']=='done'){
          doneTasks.add(element);}
        else{
          archivedTasks.add(element);}
      });
      emit(GetFromDatabaseState());
    });
  }

  void updateDatabase ({
    required String status,
    required int id,
})async{
    database.rawUpdate(
       'UPDATE tasks SET status = ? WHERE id = ? ',
     [status,id],
   ).then((value){
     getFromDatabase(database);
     emit(UpdateDatabaseState());
   });
  }
  void deleteFromDatabase({
    required int id,
})async{
    database.rawDelete('DELETE FROM tasks WHERE id = ? ',[id]).then((value){
      getFromDatabase(database);
      emit(DeleteFromDatabase());
    });
  }


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isBottom,
    required IconData icon,
  }) {
    isBottomSheetShown = isBottom;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }
}
