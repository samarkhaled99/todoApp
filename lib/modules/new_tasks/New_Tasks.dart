import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/components/constant.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';

class NewTasKsScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener:(context, state){},
      builder: (context,state){
        var tasks= AppCubit.get(context).newTasks;
        return TasksBuilder(
          tasks: tasks
        ) ;
      },
    );


  }}