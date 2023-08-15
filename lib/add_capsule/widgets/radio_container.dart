
import 'package:flutter/material.dart';

class RadioContainer extends StatelessWidget {
  RadioContainer({
    super.key,
    required this.text,

    ///Value represented by this radio Container
    required this.value,

    ///The currently selected value for this group of radio Containers
    required this.groupValue,
    required this.onChanged,
  });

  final String text;
  final String groupValue;
  final String value;
  Function onChanged = (String value) {};
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        padding: EdgeInsets.all(30),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
        decoration: BoxDecoration(
            border: Border.all(
                color: value == groupValue
                    ? Color.fromARGB(255, 157, 162, 230)
                    : Color.fromARGB(255, 75, 87, 98)),
            color: value == groupValue ? Color(0xff242641) : Color(0xff293138),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
