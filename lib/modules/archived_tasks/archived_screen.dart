import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
class ArchivedTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
        listener: (BuildContext context , AppStates state){},
        builder: (context,state){
          var tasks = AppCubit.get(context).archivedTasks;
          return taskBuilder(tasks: tasks);
        }
    );
  }
}
