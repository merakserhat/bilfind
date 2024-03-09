import 'package:bilfind_app/widgets/custom_wrap.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'shimmered_post_item.dart';

class SearchLoadingShimmer extends StatelessWidget {
  const SearchLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: CustomWrap(
            widgets: List.generate(
              12,
              (index) => Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 52, 52, 52),
                  highlightColor: const Color.fromARGB(255, 81, 80, 80),
                  enabled: true,
                  child: const SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: ShimmeredPostItem(),
                  )),
            )),
      ),
    );
  }
}

