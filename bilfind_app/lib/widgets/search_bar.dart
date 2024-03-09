import 'package:bilfind_app/constants/app_theme.dart';
import 'package:flutter/material.dart';

typedef SearchCallback = void Function(String searchParam);

class CustomSearchBar extends StatefulWidget {
  final SearchCallback callbackFunction;
  final SearchCallback? onChanged;
  final String? hint;
  final Widget? leading;
  final Color fillColor;
  final double borderRadius;
  final TextEditingController controller;
  final Function(String) onSearched;

  const CustomSearchBar({
    super.key,
    this.leading,
    required this.callbackFunction,
    this.onChanged,
    this.hint,
    this.fillColor = Colors.white,
    this.borderRadius = 5,
    required this.controller,
    required this.onSearched,
  });

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void initState() {
    if (widget.onChanged != null) {
      widget.controller.addListener(() {
        widget.onChanged!(widget.controller.value.text);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        height: 35,
        child: Material(
          shadowColor: Colors.black,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          elevation: 0,
          color: AppColors.secondary,
          child: TextFormField(
            controller: widget.controller,
            obscureText: false,
            onFieldSubmitted: widget.onSearched,
            textInputAction: TextInputAction.search,
            showCursor: true,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
            textAlignVertical: TextAlignVertical.center,
            cursorColor: Colors.white,
            onEditingComplete: () {
              if (widget.controller.text.isNotEmpty) {
                FocusManager.instance.primaryFocus!.unfocus();
                widget.callbackFunction(widget.controller.value.text);
              }
            },
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.only(
                left: 24,
              ),
              hintText: widget.hint,
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white54,
                  ),
              prefixIcon: GestureDetector(
                onTap: () {
                  if (widget.controller.text.isNotEmpty) {
                    FocusManager.instance.primaryFocus!.unfocus();
                    widget.callbackFunction(widget.controller.value.text);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.search_sharp,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
