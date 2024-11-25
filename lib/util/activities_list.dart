// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({
    super.key,
    required this.nameActivity,
    required this.activityCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  final String nameActivity;
  final bool activityCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(5),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.deepPurple.shade200,
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Checkbox(
                value: activityCompleted,
                onChanged: onChanged,
                checkColor: Colors.black,
                activeColor: Colors.white,
                side: const BorderSide(color: Colors.white),
              ),
              Text(
                nameActivity,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: activityCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.white,
                    decorationThickness: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
