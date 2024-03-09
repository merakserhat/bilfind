import 'dart:html';

import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/constants/enums.dart';
import 'package:bilfind_app/models/search_filter_model.dart';
import 'package:bilfind_app/utils/routing/route_generator.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:bilfind_app/widgets/side_bar/department_filter.dart';
import 'package:bilfind_app/widgets/side_bar/price_filter.dart';
import 'package:bilfind_app/widgets/side_bar/side_category_selector.dart';
import 'package:bilfind_app/widgets/side_bar/side_home_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilterSideBar extends StatefulWidget {
  const FilterSideBar(
      {Key? key,
      required this.onFilterApplied,
      required this.searchBarController})
      : super(key: key);

  final Function(SearchFilterModel searchFilterModel) onFilterApplied;
  final TextEditingController searchBarController;

  @override
  State<FilterSideBar> createState() => _FilterSideBarState();
}

class _FilterSideBarState extends State<FilterSideBar> {
  List<String> selectedCategories = [];
  String? priceValidationError;
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  Departments? _selectedDepartment;

  bool homeSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.height - 60
          : MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(
          right: BorderSide(color: Colors.white, width: 0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SideHomeButton(
                    onTap: () {
                      setState(() {
                        minPriceController.clear();
                        maxPriceController.clear();
                        selectedCategories.clear();
                        _selectedDepartment = null;
                        seeAll();

                        homeSelected = true;
                      });
                    },
                    isSelected: homeSelected,
                  ),
                  const SizedBox(height: 12),
                  SideCategorySelector(
                      selectedCategories: selectedCategories,
                      isSelected: !homeSelected,
                      onSelected: (value, isSelected) {
                        setState(() {
                          if (isSelected) {
                            selectedCategories.add(value);
                          } else {
                            selectedCategories.remove(value);
                          }
                        });
                      }),
                  const SizedBox(height: 12),
                  PriceFilter(
                    maxPriceController: maxPriceController,
                    minPriceController: minPriceController,
                    priceValidationError: priceValidationError,
                  ),
                  const SizedBox(height: 12),
                  DepartmentFilter(
                    label: "Departments",
                    onChanged: (Departments? selectedDepartment) {
                      setState(() {
                        _selectedDepartment = selectedDepartment;
                      });
                    },
                    selectedDepartment: _selectedDepartment,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          AppButton(
            label: "Apply Filters",
            color: AppColors.black4,
            onPressed: applyFilters,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void seeAll() {
    SearchFilterModel searchFilterModel = SearchFilterModel(
      department: null,
      key: null,
      maxPrice: null,
      minPrice: null,
      types: null,
    );
    widget.onFilterApplied(searchFilterModel);
  }

  void applyFilters() {
    SearchFilterModel searchFilterModel = SearchFilterModel();
    int minPrice = minPriceController.text.isEmpty
        ? 0
        : int.parse(minPriceController.text);
    int maxPrice = maxPriceController.text.isEmpty
        ? -1
        : int.parse(maxPriceController.text);

    if (maxPrice != -1 && minPrice > maxPrice) {
      setState(() {
        priceValidationError = "Max price should be bigger than min price.";
      });
      return;
    }
    setState(() {
      priceValidationError = null;
    });

    if (minPrice > 0) {
      searchFilterModel.minPrice = minPrice;
    }
    if (maxPrice > 0) {
      searchFilterModel.maxPrice = maxPrice;
    }

    // if (widget.searchBarController.text.isNotEmpty) {
    //   searchFilterModel.key = widget.searchBarController.text;
    // }

    if (selectedCategories.isNotEmpty) {
      searchFilterModel.types = selectedCategories;
    }

    //May be problematic
    if (_selectedDepartment != null) {
      searchFilterModel.department = _selectedDepartment;
    }

    if (_selectedDepartment == null &&
        selectedCategories.isEmpty &&
        maxPrice <= 0 &&
        minPrice <= 0) {
      setState(() {
        homeSelected = true;
      });
    } else {
      setState(() {
        homeSelected = false;
      });
    }

    widget.onFilterApplied(searchFilterModel);
  }
}
