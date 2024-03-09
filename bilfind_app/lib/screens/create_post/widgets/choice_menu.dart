import 'package:bilfind_app/screens/create_post/widgets/post_type_choice_button.dart';
import 'package:bilfind_app/widgets/custom_wrap.dart';
import 'package:bilfind_app/widgets/responsive.dart';
import 'package:flutter/material.dart';

String imageForSale =
    "https://bilfind.fra1.cdn.digitaloceanspaces.com/icons/icons8-sale-64.png";
String imageForRequest =
    "https://bilfind.fra1.cdn.digitaloceanspaces.com/icons/icons8-pray-96.png";
String imageForLost =
    "https://bilfind.fra1.cdn.digitaloceanspaces.com/icons/icons8-lost-and-found-100.png";
String imageForFound =
    "https://bilfind.fra1.cdn.digitaloceanspaces.com/icons/icons8-picking-money-100.png";
String imageForDonation =
    "https://bilfind.fra1.cdn.digitaloceanspaces.com/icons/icons8-help-100.png";
String imageForBorrow =
    "https://bilfind.fra1.cdn.digitaloceanspaces.com/icons/icons8-book-85.png";
String imageForForum =
    "https://bilfind.fra1.cdn.digitaloceanspaces.com/icons/icons8-mask-96.png";
String imageForRent =
    "https://bilfind.fra1.cdn.digitaloceanspaces.com/icons/icons8-rent-64.png";

class ChoiceModel {
  final String image;
  final String label;
  final String type;

  ChoiceModel({required this.image, required this.label, required this.type});
}

class ChoiceMenu extends StatelessWidget {
  ChoiceMenu({super.key, required this.onSelected});

  final Function(String) onSelected;

  final List<ChoiceModel> types = [
    ChoiceModel(image: imageForSale, label: "Sale", type: "SALE"),
    ChoiceModel(image: imageForLost, label: "Lost", type: "LOST"),
    ChoiceModel(image: imageForFound, label: "Found", type: "FOUND"),
    ChoiceModel(image: imageForDonation, label: "Donation", type: "DONATION"),
    ChoiceModel(image: imageForBorrow, label: "Borrow", type: "BORROW"),
    ChoiceModel(image: imageForRequest, label: "Request", type: "REQUEST"),
    ChoiceModel(image: imageForRent, label: "Rent", type: "RENT"),
    ChoiceModel(image: imageForForum, label: "Forum", type: "FORUM"),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomWrap(
      cs: Responsive.isDesktop(context) ? 4 : 2,
      widgets: List.generate(
        types.length,
        (index) => PostTypeChoiceButton(
            type: types[index].type,
            image: types[index].image,
            onSelected: onSelected),
      ),
    );
  }
}
