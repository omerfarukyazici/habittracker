
import '../models/habit.dart';

// Given habit list of completion day
// Is the habit completed today?
bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any((date) =>
  date.year == today.year &&
      date.month == today.month &&
      date.day == today.day
  ); // Kapanış parantezi doğru konumda
}
//prepare heatmap datasets
Map<DateTime,int> prepareMapDataset(List<Habit> habits){
  Map<DateTime,int> dataset = {};


  for (var habit in habits){
    for(var date in habit.completedDays){
      //normalize date to avoid time mismatch
      final normalizedDate = DateTime(date.year,date.month,date.day);

      //if the date already exist in the dataset,increment its count
      if(dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate]= dataset[normalizedDate]! +1;

      }else{
        //else
        dataset[normalizedDate]=1;
      }

    }
  }
  return dataset;
}