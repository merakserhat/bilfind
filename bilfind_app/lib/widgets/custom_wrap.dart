import 'package:flutter/material.dart';
import 'dart:math';

class CustomWrap extends StatelessWidget {
  const CustomWrap(
      {Key? key,
      required this.widgets,
      this.size = 450,
      this.cs,
      this.contentPadding = const EdgeInsets.all(8.0)})
      : super(key: key);

  final List<Widget> widgets;
  final double size;
  final int? cs;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    int columnSize =
        cs ?? max(1, MediaQuery.of(context).size.width / size).floor();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(columnSize, (columnIndex) {
        if (widgets.isEmpty) {
          return Container();
        }

        int itemCountInsideColumn = (widgets.length / columnSize).ceil();
        return Expanded(
          child: ListView.builder(
              itemCount: itemCountInsideColumn,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, rowIndex) {
                int itemIndex = (rowIndex * columnSize) + columnIndex;

                if (itemIndex >= widgets.length) {
                  return Container();
                }

                return Padding(
                  padding: contentPadding,
                  child: widgets[itemIndex],
                );
              }),
        );
      }),
    );
  }
}
