
import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/models/user_model.dart';
import 'package:bilfind_app/screens/post_detail/widgets/post_item.dart';
import 'package:bilfind_app/widgets/custom_wrap.dart';
import 'package:flutter/material.dart';

class UserPostsSection extends StatelessWidget {
  const UserPostsSection({
    super.key,
    required this.userModel,
    required this.isMyPostActive,
    required this.userPosts,
    required this.favPosts,
  });

  final UserModel userModel;
  final bool isMyPostActive;
  final List<PostModel> userPosts;
  final List<PostModel> favPosts;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        2,
        (listIndex) {
          var activeList = (listIndex == 0 ? userPosts : favPosts);

          return Visibility(
            visible: (listIndex == 0 && isMyPostActive) ||
                (listIndex == 1 && !isMyPostActive),
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            child: CustomWrap(
              widgets: activeList
                  .map(
                    (e) => PostItem(
                      postModel: e,
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

/*
Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        2,
        (listIndex) => LayoutBuilder(
          builder: (context, constraints) => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  (constraints.maxWidth * 0.6 / 300).round(), // Two columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: (listIndex == 0 ? userPosts : favPosts).length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        width: 0, color: Color.fromARGB(255, 220, 229, 238)),
                    color: AppColors.white),
                child: PostItem(
                  postModel:
                      (listIndex == 0 ? userPosts : favPosts).elementAt(index),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
 */

// @override
// Widget build(BuildContext context) {
//   return Stack(
//     children: List.generate(
//       2,
//           (index) => Column(
//         children: (index == 0 ? userPosts : favPosts)
//             .map((e) => Visibility(
//           visible: index == 0 && isMyPostActive,
//           maintainSize: true,
//           maintainState: true,
//           maintainAnimation: true,
//           child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12.0),
//                   border: Border.all(
//                       width: 0,
//                       color: Color.fromARGB(255, 220, 229, 238)),
//                   color: AppColors.white),
//               child: PostItem(postModel: e)),
//         ))
//             .toList(),
//       ),
//     ),
//   );
// }
