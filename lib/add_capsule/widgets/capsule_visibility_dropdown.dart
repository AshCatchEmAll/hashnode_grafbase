
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CapsuleVisibilityDropdown extends StatefulWidget {
  const CapsuleVisibilityDropdown({super.key});

  @override
  State<CapsuleVisibilityDropdown> createState() =>
      _CapsuleVisibilityDropdownState();
}

class _CapsuleVisibilityDropdownState extends State<CapsuleVisibilityDropdown> {
  late final List<String> list ;

  late String dropdownValue ;

  @override
  void initState() {
    super.initState();
    list = <String>['Public', 'Private'];
    dropdownValue = list[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Color(0xff1B272F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        padding: const EdgeInsets.only(left: 8),
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        dropdownColor: const Color(0xff1B272F),
        iconEnabledColor: const Color(0xff68747D),
        style: const TextStyle(color: Color(0xffD1E4F2)),
        underline: Container(
          padding: EdgeInsets.zero,
          height: 2,
          color: Colors.transparent,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
          if (value != null)
            context.read<AddCapsuleBloc>().updateVisibility(value);
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
