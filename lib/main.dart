import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/layout/todo_app/todo_layout.dart';
import 'package:todoapp/shared/cubit/bloc_observer.dart';

void main(){
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        primarySwatch: Colors.deepOrange,
        appBarTheme: AppBarTheme(
          color: Colors.white24,
          titleSpacing: 50.0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: Colors.black54,
      ),
      debugShowCheckedModeBanner: false,
      home: TodoLayout(),
    );
  }
}