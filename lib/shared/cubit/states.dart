import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppStates{}
class AppInitialStates extends AppStates{}
class AppChangeBottomNavState extends AppStates{}
class AppCreateDBState extends AppStates{}
class AppInsertDBState extends AppStates{}
class AppGetDBState extends AppStates{}
class AppChangeBottomSheetState extends AppStates{}
class AppGetDBLoadingState extends AppStates{}
class AppUpdateDBState extends AppStates{}
class AppDeleteDBState extends AppStates{}

class NewsAppChangeModeState extends AppStates{}

