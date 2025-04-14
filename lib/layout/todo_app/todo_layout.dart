import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archived_tasks/archived_screen.dart';
import 'package:todoapp/modules/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/modules/new_tasks/new_tasks_screen.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class TodoLayout extends StatelessWidget {

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is InsertToDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text(cubit.title[cubit.currentIndex])),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              backgroundColor: Colors.white10,
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.deepOrange,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  label: 'Tasks',
                  icon: Icon(Icons.menu_open),
                ),
                BottomNavigationBarItem(
                  label: 'Done',
                  icon: Icon(Icons.check_sharp),
                ),
                BottomNavigationBarItem(
                  label: 'Archived',
                  icon: Icon(Icons.archive_sharp),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Colors.deepOrange,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      taskTitle: titleController.text,
                      taskdate: dateController.text,
                      taskTime: timeController.text,
                    );
                    // ).then((value) {
                    //     Navigator.pop(context);
                    //       cubit.isBottomSheetShown = false;
                    //       cubit.fabIcon=Icons.edit;
                    //       cubit.tasks=value;
                    //       print(cubit.tasks);
                    // });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.black45,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10.0),
                                defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.text,
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                ),
                                SizedBox(height: 10.0),
                                defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.text,
                                  label: 'Task Date',
                                  prefix: Icons.date_range_outlined,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2025-07-13'),
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMd()
                                          .format(value!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 25.0,
                      )
                      .closed
                      .then((value) {
                        cubit.changeBottomSheetState(isBottom: false, icon: Icons.edit);

                      });
                  cubit.changeBottomSheetState(isBottom: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon, color: Colors.black),
            ),
            body: ConditionalBuilder(
              condition: state is! AppLoadingState,
              builder: (context) {
                return cubit.currentScreen[cubit.currentIndex];
              },
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}
