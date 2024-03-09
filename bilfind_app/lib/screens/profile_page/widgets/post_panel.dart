// import 'package:bilfind_app/models/response/post_model.dart';
// import 'package:bilfind_app/screens/post_detail/widgets/like_button.dart';
// import 'package:bilfind_app/screens/post_detail/widgets/post_item.dart';
// import 'package:flutter/material.dart';
//
// class PostPanel extends StatelessWidget {
//   const PostPanel({super.key, required this.postModel});
//   final PostModel postModel;
//
//   @override
//   Widget build(BuildContext context) {
//
//       return Container(
//         height: 400,
//         width: 400,
//         child: PostItem(postModel: postModel),
//       );
//   }
// }
//
// //     return Container(
// //       child: Column(
// //         children: [
// //           Row(),
// //           Expanded(
// //             child: ListView.builder(
// //               scrollDirection: Axis.horizontal,
// //               itemCount: postModel.postImages.length,
// //               itemBuilder: (BuildContext context, int index) {
// //                 return Padding(
// //                   padding: const EdgeInsets.all(4.0),
// //                   child: Container(
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(12.0),
// //                     ),
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(12.0),
// //                       child: Image.network(
// //                         postModel.postImages.elementAt(index),
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             mainAxisAlignment: MainAxisAlignment.start,
// //             children: [
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Container(
// //                       alignment: Alignment.centerLeft,
// //                       child: Text(postModel.title,
// //                           style: Theme.of(context)
// //                               .textTheme
// //                               .headlineSmall!
// //                               .copyWith(fontSize: 18))),
// //                   const LikeButton()
// //                 ],
// //               ),
// //               Container(
// //                 alignment: Alignment.topLeft,
// //                 height: 160,
// //                 child: SingleChildScrollView(
// //                     child: Text(postModel.description,
// //                         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
// //                             fontWeight: FontWeight.w300,
// //                             color: Colors.black54))),
// //               )
// //             ],
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }
