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

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // Belirtilen alışkanlığı bul
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);

        // Eğer tamamlandıysa, bugünün tarihini completedDays listesine ekle
        if (isCompleted && !habit.completedDays.contains(todayDate)) {
          habit.completedDays.add(todayDate);
        }
        // Eğer tamamlanmadıysa bugünün tarihini listeden çıkar
        else if (!isCompleted) {
          habit.completedDays.removeWhere((date) =>
          date.year == today.year &&
              date.month == today.month &&
              date.day == today.day);
        }

        await isar.habits.put(habit);
      });

      readHabits(); // UI güncellemek için
    }
  }

  Future<void> updateHabitName(int id, String newName) async {
    // Belirtilen alışkanlığı bul
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        // Alışkanlık ismini güncelle
        habit.name = newName;
        await isar.habits.put(habit);
      });

      readHabits(); // UI güncellemek için
    }
  }

  //Delete

  Future<void>deleteHabit(int id) async {
    await isar.writeTxn(() async{
      await isar.habits.delete(id);
    });
    readHabits();
  }



}