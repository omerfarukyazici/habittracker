import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/app_settings.dart';
import '../models/habit.dart';
class HabitDatabase extends ChangeNotifier{
  static late Isar isar;




  //INITALIZE DATABASE
  static Future<void> initialize() async{
    final dir = await getApplicationDocumentsDirectory();
    isar= await Isar.open(
        [HabitSchema, AppSettingsSchema],
        directory: dir.path);
  }

  //save first date of app startup

  Future<void> saveFirstLaunchDate()async{
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings==null){
      final settings = AppSettings()..firstLaunchDate=DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }


  //get first date of app startup
  Future<DateTime?>getFirstLaunchDate() async{
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

   //list habit
  final List<Habit> currentHabits = [];

  //CREATE ADD new habbit
  Future<void> addHabit(String habitName) async{
    //create a new habit
    final newHabit=Habit()..name=habitName;
    
    //save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //re-read from db
    readHabits();
  }


  //READ read saved habits from db
  Future<void>readHabits()async{
    //fetch all habits from db
   List<Habit> fetchedHabits = await isar.habits.where().findAll();
    //give to current habits
    currentHabits.clear();

    currentHabits.addAll(fetchedHabits);

    //update UI
    notifyListeners();
  }

  //UPDATE -check habit on and off

  Future<void> updateHabitCompletion(int id, bool isCompleted) async{
    //find spesific habit
    final habit =await isar.habits.get(id);

    //update completion status

    if(habit != null){
      await isar.writeTxn(()async{
        //if habit completed -> add the current date to completed days list
        if(isCompleted && !habit.completedDays.contains(DateTime.now())){
          //today
          final today =DateTime.now();

          habit.completedDays.add(DateTime(today.year,today.month,today.day));
          //eğer habit tamamlanmadıysa o listeden çıkartılır
        }else {
          habit.completedDays.removeWhere((date) =>
          date.year==DateTime.now().year&&
          date.month==DateTime.now().month&&
          date.day==DateTime.now().day
          );

        }
        await isar.habits.put(habit);
      });
      readHabits();
    }
    //update- edit habit name
    Future<void> updateHabitName(int id, String newName) async {
      //find spesific habit
      final habit =await isar.habits.get(id);

      //update habit name
      if(habit != null){
        //update name
        await isar.writeTxn(() async{
          habit.name=newName;
          await isar.habits.put(habit);
        });
      }
    }
    readHabits();
  }
  //Delete

  Future<void>deleteHabit(int id) async {
    await isar.writeTxn(() async{
      await isar.habits.delete(id);
    });
    readHabits();
  }



}