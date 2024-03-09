import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/widgets/side_bar/price_filter_field.dart';
import 'package:flutter/material.dart';

class PriceFilter extends StatelessWidget {
  const PriceFilter({
    Key? key,
    required this.minPriceController,
    required this.maxPriceController,
    this.priceValidationError,
  }) : super(key: key);

  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final String? priceValidationError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Price",
          textAlign: TextAlign.start,
          style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: AppColors.mutedWhite),
        ),
        Row(
          children: [
            Expanded(
                child: PriceFilterField(
              hint: "Min",
              controller: minPriceController,
            )),
            const SizedBox(width: 4),
            Container(
              width: 4,
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: AppColors.mutedWhite,
            ),
            const SizedBox(width: 4),
            Expanded(
                child: PriceFilterField(
              hint: "Max",
              controller: maxPriceController,
            )),
          ],
        ),
        priceValidationError == null
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(
                  priceValidationError!,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.red),
                ),
              )
      ],
    );
  }
}
