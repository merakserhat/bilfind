import 'dart:typed_data';

import 'package:bilfind_app/constants/enums.dart';

class CreatePostRequest {
  final String title;
  final String content;
  final String postType;
  final int? price;
  final List<Uint8List> images;

  CreatePostRequest({
    required this.title,
    required this.content,
    required this.postType,
    required this.price,
    required this.images,
  });
}
