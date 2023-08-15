
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CapsuleSchedulePicker extends StatelessWidget {
  
  
  final format = DateFormat("yyyy/MM/dd HH:mm");
  @override
  Widget build(BuildContext widgetContext) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff293138),
      ),
      width: 160,
      child: DateTimeField(
         resetIcon: null,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xff1B272F),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          labelText: 'Schedule',
          labelStyle: const TextStyle(
              color: Color(0xffDAD4D4),
              fontSize: 11,
              fontWeight: FontWeight.bold),
        ),
        style: const TextStyle(
            color: Color(0xffDAD4D4),
            fontSize: 12,
            fontWeight: FontWeight.bold),
        format: format,
       
        onShowPicker: (context, currentValue) async {
          final schedule = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100),
          ).then((DateTime? date) async {
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          });
          if(schedule == null) return currentValue;

          // if schedule is time before now, show snackbar
          if(schedule.isBefore(DateTime.now())){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Schedule cannot be before now"),
                backgroundColor: Colors.red,
              )
            );
            return currentValue;
          }

          widgetContext.read<AddCapsuleBloc>().updateCron(schedule);
          return schedule;
        },
      ),
    );
  }
}
