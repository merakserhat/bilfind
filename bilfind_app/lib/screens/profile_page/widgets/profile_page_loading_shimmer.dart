import 'package:bilfind_app/screens/search/widgets/shimmered_post_item.dart';
import 'package:bilfind_app/widgets/custom_wrap.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePageLoadingShimmer extends StatelessWidget {
  const ProfilePageLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomWrap(
          widgets: List.generate(
        8,
        (index) => Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 52, 52, 52),
            highlightColor: const Color.fromARGB(255, 81, 80, 80),
            enabled: true,
            child: const SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: ShimmeredPostItem(),
            )),
      )),
    );
  }
}
