import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:habbitwithomer/components/my_drawer.dart';
import 'package:habbitwithomer/components/my_habit_tile.dart';
import 'package:habbitwithomer/components/my_heat_map.dart';
import 'package:habbitwithomer/database/habit_database.dart';
import 'package:habbitwithomer/themes/theme_provider.dart';
import 'package:provider/provider.dart';

import '../database/habit_database.dart';
import '../models/habit.dart';
import '../util/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();



}



class _HomePageState extends State<HomePage> {

  @override
  void initState() {
   //read exiting habits on startup

    Provider.of<HabitDatabase>(context,listen: false).readHabits();
    super.initState();
  }

  //text controller
  final TextEditingController textController = TextEditingController();
   //create new habit

  void createNewHabit(){
    showDialog(context: context, builder: (context) =>
        AlertDialog(
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: "Create a new habit"
            ),
          ),
          actions: [
            //save button
            MaterialButton(onPressed: () {
              //get the new habit name
              String newHabitName=textController.text;

              //save to db
              context.read<HabitDatabase>().addHabit(newHabitName);

              //pop box

              Navigator.pop(context);

              //clear controller
              textController.clear();
            },
              child: const Text("Save"),
            ),
            //cancel button

            MaterialButton(onPressed: () {
              //pop box
              Navigator.pop(context);

              //clear text conroller
              textController.clear();

            },
            child: const Text("Clear"),)
          ],
        ),

    );
  }

  //check habit on off
  void checkHabitOnOff(bool? value, Habit habit){
    //update completion status
    if(value !=null){
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }

  }


  void editHabitBox(Habit habit){
    //set the controllers text to the habit's name
    textController.text=habit.name;

    showDialog(context: context, builder: (context) =>
        AlertDialog(
          content: TextField(controller:textController,),
        actions: [

          //save button
          MaterialButton(onPressed: () {
            //get the new habit name
            String newHabitName=textController.text;

            //save to db
            context.read<HabitDatabase>().updateHabitName(habit.id,newHabitName);

            //pop box

            Navigator.pop(context);

            //clear controller
            textController.clear();
          },
            child: const Text("Save"),
          ),
          //cancel button

          MaterialButton(onPressed: () {
            //pop box
            Navigator.pop(context);

            //clear text conroller
            textController.clear();

          },
            child: const Text("Clear"),)

        ],
        ),

    );
  }
//delete habit box
  void deleteHabitBox(Habit habit){
    showDialog(context: context, builder: (context) =>
        AlertDialog(
          title: Text("Are you sure want to delete"),
          actions: [

            //delete button
            MaterialButton(onPressed: () {

              //save to db
              context.read<HabitDatabase>().deleteHabit(habit.id);

              //pop box

              Navigator.pop(context);

              //clear controller
            },
              child: const Text("Delete"),
            ),
            //cancel button

            MaterialButton(onPressed: () {
              //pop box
              Navigator.pop(context);

            },
              child: const Text("Clear"),)

          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,


        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add
        ),
),
      body: ListView(
        children: [

          //HEATMAP
          _buildHeatMap(),


          //HABİT LİST
          _buildHabitList()
        ],
      ),

    );
  }

Widget _buildHeatMap(){
    //habit database
  final habitDatabase=context.watch<HabitDatabase>();

  //curretnt habits
  List<Habit> currentHabits= habitDatabase.currentHabits;

  //return heat map UI
  return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
    builder: (context, snapshot) {

        //once the data is available build heatmap
        if (snapshot.hasData){
          return MyHeatMap(startDate: snapshot.data!, datasets: prepareMapDataset(currentHabits));
        }
        else {
          return Container();
        }

      },);

}
Widget _buildHabitList(){

    //habit db
  final habitDatabase = context.watch<HabitDatabase>();

  //current habits
  List<Habit> currentHabits=habitDatabase.currentHabits;

  //return list of habits ui
  return ListView.builder(
    itemCount: currentHabits.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {

    //get each inviduial habit
      final habit=currentHabits[index];


      //check if habit completed today

      bool isCompletedToday=isHabitCompletedToday(habit.completedDays);
    //return habit tale ui

      return MyHabitTile(
        text:habit.name,
        isCompleted: isCompletedToday,
        onChanged: (value) => checkHabitOnOff(value,habit),
        editHabit: (context) => editHabitBox(habit),
        deleteHabit: (context) => deleteHabitBox(habit),

      );

  },);

}

}

