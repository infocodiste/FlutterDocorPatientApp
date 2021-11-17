import 'package:book_my_doctor/src/theme/light_color.dart';
import 'package:book_my_doctor/src/theme/text_styles.dart';
import 'package:book_my_doctor/src/theme/extention.dart';
import 'package:flutter/material.dart';

class SlotView<T> extends StatelessWidget {
  final List<T> items;
  final T select;
  final Function onChange;
  final bool hasWrap;

  SlotView(this.items, this.select, {this.hasWrap = false, this.onChange});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<int, T> mappedItems = items.asMap();

    List<Widget> slots = mappedItems.entries
        .map((MapEntry<int, T> mapEntry) => Container(
              width: size.width * (hasWrap ? 0.21 : 0.37),
              height: 56,
              margin: hasWrap ? EdgeInsets.zero : EdgeInsets.all(4),
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: mapEntry.value == select
                      ? LightColor.purple
                      : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                      color: mapEntry.value == select
                          ? LightColor.purple
                          : LightColor.purple)),
              alignment: Alignment.center,
              child: Text(
                mapEntry.value.toString(),
                textAlign: TextAlign.center,
                style: mapEntry.value == select
                    ? TextStyles.bodySm.white.bold
                    : TextStyles.bodySm.purple.bold,
              ),
            ).ripple(
              () {
                this.onChange(items[mapEntry.key]);
              },
              borderRadius: BorderRadius.circular(0),
            ))
        .toList();

    return StatefulBuilder(
      builder: (_, StateSetter setState) => hasWrap
          ? Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots,
            ).alignCenterLeft
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: slots,
              ),
            ),
    );
  }
}
