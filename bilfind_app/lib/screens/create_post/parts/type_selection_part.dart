import 'package:bilfind_app/screens/create_post/widgets/choice_menu.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';

class TypeSelectionPart extends StatelessWidget {
  const TypeSelectionPart({super.key, required this.onSelected});

  final Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Responsive(
          mobile: getMobileView(),
          tablet: getMobileView(),
          desktop: getDesktopView()),
    );
  }

  Widget getMobileView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        const Text("Select Post Type",
            style: TextStyle(color: Colors.white, fontSize: 24)),
        const SizedBox(height: 36),
        ChoiceMenu(onSelected: onSelected),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget getDesktopView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        const Text("Select Post Type",
            style: TextStyle(color: Colors.white, fontSize: 24)),
        const SizedBox(height: 36),
        Row(
          children: [
            const Spacer(
              flex: 1,
            ),
            Flexible(flex: 2, child: ChoiceMenu(onSelected: onSelected)),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
