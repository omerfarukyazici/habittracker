import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habbitwithomer/components/my_drawer.dart';
import 'package:habbitwithomer/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();



}



class _HomePageState extends State<HomePage> {

  //text controller
  final TextEditingController textController = TextEditingController();
   //create new habit

  void createNewHabit(){
    showDialog(context: context, builder: (context) =>
        AlertDialog(
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "Create a new habit"
            ),
          ),
          actions: [
            //save button
            //cancel button
          ],
        ),

    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,


        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add
        ),
),

    );
  }}

