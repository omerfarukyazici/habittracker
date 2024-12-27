import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;


  const MyHabitTile({super.key,
    required this.isCompleted,
    required this.text,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit
  });
//habitleri silerken ya da düzenlerken kullandığımız yer
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          //edit option
          SlidableAction(onPressed: editHabit,
          backgroundColor: Colors.grey.shade800,
            icon: Icons.settings,
            borderRadius: BorderRadius.circular(8),
          ),

          //delete option
          SlidableAction(onPressed: deleteHabit,
            backgroundColor: Colors.red.shade800,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),
          ),

        ],
      ),
      child: GestureDetector(
        onTap: () {
          if(onChanged !=null){
            onChanged!(!isCompleted);
          }
        },
        //habit tile
        child: Container(
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8)
          ),
          padding: EdgeInsets.all(12),
          child: ListTile(
            title: Text(text,style: TextStyle(
              color: isCompleted ? Colors.white:Theme.of(context).colorScheme.inversePrimary
            ),),
            //checkbox
            leading: Checkbox(
              activeColor: Colors.green,
              value: isCompleted,
              onChanged: onChanged,
        
            ),
          ),
        ),
      ),
    );

  }
}
