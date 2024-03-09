import 'dart:typed_data';

class EditPostRequest {
  final String postId;
  final String content;
  final String title;
  final int? price;
  final List<Uint8List> images;
  final List<String> previousImages;

  EditPostRequest({
    required this.title,
    required this.content,
    required this.postId,
    required this.price,
    required this.images,
    required this.previousImages,
  });
}
