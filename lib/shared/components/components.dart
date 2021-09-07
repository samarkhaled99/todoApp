import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius =0.0,
  @required String text ,
  @required Function function,
})=>
    Container(
      width: width,
      child: MaterialButton(
        onPressed: function,
        child:  Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(

          ),
        ),
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

Widget defaultTextForm({
  @required TextEditingController controller,
  @required TextInputType type,
  @required String Label,
  @required Function validate,
  @required IconData prefix,
  bool isPassword = false,
  IconData suffix,
  Function suffixPressed,
  Function onSubmit,
  Function onChange,
  Function onTape,
  //bool isClickable = true,


})=>
    TextFormField
      (
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTape,
      validator: validate,
    //  enabled: isClickable,
      decoration: InputDecoration(
        labelText: Label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix!= null ?IconButton(onPressed: suffixPressed,icon: Icon(suffix)):null,
        border:OutlineInputBorder(),
      ),
    );
 Widget buildTaskItem(Map model, context) => Dismissible(
   key: Key(model['id'].toString()),
   child: Padding(
padding: const EdgeInsets.all(20.0),
child: Row(
children: [
CircleAvatar(
radius: 40.0,
child: Text('${model['time']}'),
),
SizedBox(width: 20.0),
Expanded(
    child:   Column(

    mainAxisSize: MainAxisSize.min,

    mainAxisAlignment: MainAxisAlignment.start,

    children: [

    Text('${model['title']}', style: TextStyle(

    fontWeight: FontWeight.bold, fontSize: 15.0,

    ),),

    Text('${model['date']}', style: TextStyle(

    color: Colors.grey

    ),),

    ],

    ),
),
    SizedBox(width: 20.0),
    IconButton(icon: Icon(Icons.check_box, color: Colors.green,), onPressed:(){
      AppCubit.get(context).UpdateData(status:'done' , id: model['id']);
    }),
    IconButton(icon: Icon(Icons.archive, color: Colors.black45,), onPressed:(){
      AppCubit.get(context).UpdateData(status:'archive' , id: model['id']);
    }),
],
),
),
   onDismissed: (direction){
AppCubit.get(context).deleteData(id: model['id']);
   },
 );

 Widget TasksBuilder({
  @required List <Map> tasks,
}) =>ConditionalBuilder(
   condition: tasks.length>0,
   builder: (context)=>ListView.separated(
       itemBuilder: (context,index)=>buildTaskItem(tasks[index], context),
       separatorBuilder:( context,index)=> Container(
         width: double.infinity,
         height: 1.0,
         color: Colors.grey[300],
       ),
       itemCount: tasks.length),
   fallback:(context)=>Center(
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Icon(Icons.menu, size: 100.0,color: Colors.grey,),
         Text('No Tasks yet, Please Add Some Tasks', style: TextStyle(
             fontSize: 16.0,
             fontWeight: FontWeight.bold,
             color: Colors.grey
         ),)
       ],
     ),
   ) ,
 );