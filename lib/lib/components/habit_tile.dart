import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;
  final String habitId;

  const HabitTile(
      {super.key,
      required this.habitName,
      required this.habitCompleted,
      required this.onChanged,
      required this.settingsTapped,
      required this.deleteTapped,
      required this.habitId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Slidable(
            endActionPane: ActionPane(
              motion: StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: settingsTapped,
                  backgroundColor: Colors.grey.shade800,
                  icon: Icons.settings,
                  borderRadius: BorderRadius.circular(12),
                ),
                SlidableAction(
                  onPressed: deleteTapped,
                  backgroundColor: Colors.red.shade400,
                  icon: Icons.delete,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: habitCompleted,
                    onChanged: onChanged,
                  ),
                  Text(habitName),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Icon(
              Icons.arrow_forward,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
