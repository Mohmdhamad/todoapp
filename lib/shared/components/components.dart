import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  required String? Function(String?) validate,
  Function(String)? onChange,
  Function(String)? onSubmit,
  VoidCallback? onTap,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isPassword = false,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: suffix != null
          ? IconButton(
        onPressed: suffixPressed,
        icon: Icon(suffix),
      )
          : null,
      border: const OutlineInputBorder(),
    ),
    onChanged: onChange,
    onTap: onTap,
    onFieldSubmitted: onSubmit,
    validator: validate,
  );
}
Widget buildTaskItem(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 10.0
    ),
    child: Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.blueGrey,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black87,
            radius: 35.0,
            child: Text('${model['time']}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
            ),
          ),
          SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${model['title']}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text('${model['date']}',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 17.0,
                ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.0,),
          IconButton(
            onPressed: (){
              AppCubit.get(context).updateDatabase(status: 'done', id: model['id'],);
            },
              icon: Icon(Icons.check_circle),
            color: Colors.green,
          ),
          SizedBox(width: 10.0,),
          IconButton(
            onPressed: (){
              AppCubit.get(context).updateDatabase(status: 'archived', id: model['id'],);
            },
              icon: Icon(Icons.archive_outlined,),
              color: Colors.black,
            ),
        ],
      ),
    ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteFromDatabase(id: model['id']);
  },
);
Widget taskBuilder({
  required List<Map> tasks ,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder:
      (context) => ListView.separated(
    itemBuilder:
        (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => SizedBox(height: 0.0),
    itemCount: tasks.length,
  ),
  fallback:
      (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu_open, size: 65.0, color: Colors.grey[700]),
        Text(
          'No Tasks Yet',
          style: TextStyle(
            fontSize: 45.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  ),
);

