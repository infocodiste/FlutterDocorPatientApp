import 'package:book_my_doctor/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:book_my_doctor/src/theme/extention.dart';

import 'rectangle_button.dart';

/// Requires a list of string ['Male','Female','Other'] only once.

class GenderField extends StatelessWidget {
  final List<String> genderList;
  final String select;
  final Function onChange;

  GenderField(this.genderList, this.select, this.onChange);

  @override
  Widget build(BuildContext context) {
    Map<int, String> mappedGender = genderList.asMap();

    return StatefulBuilder(
      builder: (_, StateSetter setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ...mappedGender.entries.map(
                (MapEntry<int, String> mapEntry) =>
                    Wrap(alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        children: [
                  RectangleButton(
                    text: mapEntry.value,
                    tick: mapEntry.value == select,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    press: () {
                      this.onChange(genderList[mapEntry.key]);
                    },
                  )
                ]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
