import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/constants/enums.dart';
import 'package:bilfind_app/widgets/side_bar/filter_selector_item.dart';
import 'package:flutter/material.dart';

class SideCategorySelector extends StatefulWidget {
  const SideCategorySelector(
      {Key? key,
      required this.onSelected,
      required this.selectedCategories,
      required this.isSelected})
      : super(key: key);

  final Function(String, bool) onSelected;
  final List<String> selectedCategories;
  final bool isSelected;

  @override
  State<SideCategorySelector> createState() => _SideCategorySelectorState();
}

class _SideCategorySelectorState extends State<SideCategorySelector> {
  bool selectorOpen = false;
  final Map<String, String> categories = {
    "SALE": "Sale Item",
    "BORROW": "Borrow Item",
    "DONATION": "Donations",
    "FOUND": "Found Items",
    "LOST": "Lost Item",
    "REQUEST": "Requested Item",
    "RENT": "Rent Item",
    "FORUM": "Forum"
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: selectorOpen ? 440 : 64,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectorOpen = !selectorOpen;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color:
                        !selectorOpen ? Colors.transparent : AppColors.black4,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: widget.isSelected
                              ? AppColors.bilkentBlue
                              : AppColors.black4,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                        "Categories",
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: AppColors.mutedWhite),
                      ))
                    ],
                  ),
                ),
              ),
              selectorOpen ? const SizedBox(height: 12) : Container(),
              selectorOpen
                  ? Column(
                      children: List.generate(
                        categories.values.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          child: FilterSelectorItem(
                              postType: categories.keys.toList()[index],
                              isSelected: widget.selectedCategories
                                  .contains(categories.keys.toList()[index]),
                              name: categories.values.toList()[index],
                              onSelectionChange: widget.onSelected),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
