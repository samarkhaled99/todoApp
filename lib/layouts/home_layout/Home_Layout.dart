
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archived_screen/Archived_Screen.dart';
import 'package:todoapp/modules/done_screen/Done_Screen.dart';
import 'package:todoapp/modules/new_tasks/New_Tasks.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/components/constant.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';
class HomeLayout extends StatelessWidget {


  var scaffoldkey=GlobalKey<ScaffoldState>();
  var formkey= GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  Future<void> _selectedDate(BuildContext context) async{
    final DateTime _date = await  showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.tryParse(DateFormat('yyyy-MM-dd hh:mm').format(DateTime.utc(1990))),
      lastDate: DateTime.tryParse(DateFormat('yyyy-MM-dd hh:mm').format(DateTime.utc(2200))),
    );
    if(_date != null){
      dateController.text= _date.toString();
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, AppStates state){
          if (state is AppInsertDBState)
            {
               Navigator.pop(context); 
            }
        },
        builder: (BuildContext context, AppStates state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.titels[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDBLoadingState,
              builder: (context)=>cubit.screens[cubit.currentIndex],
              fallback: (context)=>Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {

                /*
              getName().then(( value) {
                print (value);
                print('adham');
                throw('error!');
              }).catchError((onError) {
                print('error is ${onError.toString()}');
              });   */

                if (cubit.isBottomSheetShown){

                  if(formkey.currentState.validate()){
                    cubit.insertToDatabase(title:titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                /*    insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    ).then((value) {
                      getDataFromDatabase(database).then((value) {
                        Navigator.pop(context);

                        /*      setState(() {
                        isBottomSheetShown=false;
                        fabIcon=Icons.edit;
                        tasks=value;
                        print (tasks);
                      }); */
                      });
                    });
                    */
                  }
                }
                else {
                  scaffoldkey.currentState.showBottomSheet((context) =>
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultTextForm(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  Label: 'Task Title',
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return ('title must not be empty');
                                    }
                                    return null;
                                  },
                                  prefix: Icons.title),
                              SizedBox(height: 15.0),
                              defaultTextForm(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTape: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text=value.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  Label: 'Task Time',
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return ('time must not be empty');
                                    }
                                    return null;
                                  },
                                  prefix: Icons.watch_later_outlined),
                              SizedBox(height: 15.0),
                              defaultTextForm(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTape: () => _selectedDate(context),
                                  Label: 'Task Date',
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return ('date must not be empty');
                                    }
                                    return null;
                                  },
                                  prefix: Icons.calendar_today),


                            ],
                          ),
                        ),
                      ),
                    elevation: 20.0,

                  ).closed.then((value) {
                  cubit.changeBottomSheetState(isShow: false, icon: Icons.edit) ;

                  });
                   cubit.changeBottomSheetState(isShow: true, icon: Icons.add) ;
                 
                }
                //cubit.getDataFromDatabase(database);
              },
              /* async
            {
              try
              {
                var name = await getName();
                print (name);
                 print ('Adham');
                throw ('some errors!!');
              } catch (error)
              {
              print('error ${error.toString()}');
            }} */
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              // showSelectedLabels: false,
              //elevation: 10.0,
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index){
              cubit.ChangeIndex(index);
                /*  setState(() {

              });*/
              },
              items: [
                BottomNavigationBarItem(
                  icon:Icon(
                      Icons.menu),
                  label: 'Tasks',


                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline
                    ), label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.archive_outlined),
                    label: 'Archived'),

              ],
            ),

          );
        },

      ),
    );
  }
  /* Future <String> getName() async
  {
    return 'samar khaled';
  } */

}


