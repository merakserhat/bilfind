import 'package:bilfind_app/constants/app_theme.dart';
import 'package:bilfind_app/constants/enums.dart';
import 'package:bilfind_app/models/post_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/request/create_post_request.dart';
import 'package:bilfind_app/models/request/edit_post_request.dart';
import 'package:bilfind_app/screens/create_post/widgets/post_form_dropdown_item.dart';
import 'package:bilfind_app/screens/create_post/widgets/post_form_item.dart';
import 'package:bilfind_app/screens/create_post/widgets/post_image_creator.dart';
import 'package:bilfind_app/services/post_service.dart';
import 'package:bilfind_app/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostForm extends StatefulWidget {
  const PostForm({
    super.key,
    required this.type,
    required this.setMockModel,
    this.postModel,
  });
  final String type;
  final Function(PostModel) setMockModel;
  final PostModel? postModel;

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  List<SelectedImage> selectedImages = [];
  List<String> previousImages = [];
  bool isLoading = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? priceError;
  String? contentError;
  String? titleError;

  Departments? postDepartment;

  @override
  void initState() {
    super.initState();

    if (widget.postModel != null) {
      titleController.text = widget.postModel!.title;
      descriptionController.text = widget.postModel!.content;
      priceController.text = widget.postModel!.price == null
          ? ""
          : widget.postModel!.price!.toString();

      previousImages = widget.postModel!.images;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: MediaQuery.of(context).size.height,
      width: 300,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text("Post Type: ${widget.type}",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white, fontSize: 22)),
            PostImageCreator(
              onChange: (image) {
                if (selectedImages.contains(image)) {
                  selectedImages.remove(image);
                } else {
                  selectedImages.add(image);
                }

                widget.setMockModel(_getMockPostModel());
                setState(() {});
              },
              onDeletePrevious: (String value) {
                setState(() {
                  previousImages.remove(value);
                  widget.setMockModel(_getMockPostModel());
                });
              },
              selectedImages: selectedImages,
              previousImages: previousImages,
            ),
            PostFormItem(
              controller: titleController,
              hintText: "Title",
              error: titleError,
              onChange: (_) {
                widget.setMockModel(_getMockPostModel());
              },
            ),
            widget.type == "SALE" || widget.type == "RENT"
                ? PostFormItem(
                    controller: priceController,
                    hintText: "Price",
                    error: priceError,
                    isNumber: true,
                    onChange: (_) {
                      widget.setMockModel(_getMockPostModel());
                    },
                  )
                : Container(),
            PostFormDropDownItem(
              label: "Department",
              onChanged: (Departments? value) {
                setState(() {
                  postDepartment = value;
                });
              },
              item: postDepartment,
            ),
            PostFormItem(
                controller: descriptionController,
                hintText: "Description",
                error: contentError,
                onChange: (_) {
                  widget.setMockModel(_getMockPostModel());
                }),
            isLoading
                ? const CircularProgressIndicator(
                    color: AppColors.mutedWhite,
                  )
                : Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: AppButton(
                      label: widget.postModel == null ? "Create" : "Edit",
                      color: AppColors.black4,
                      onPressed: _onCreatePost,
                    ),
                  ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _onCreatePost() async {
    if (!_validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (widget.postModel != null) {
      EditPostRequest editPostRequest = EditPostRequest(
        postId: widget.postModel!.id,
        title: titleController.text,
        content: descriptionController.text,
        price: priceController.text.isEmpty
            ? null
            : int.parse(priceController.text),
        images: selectedImages.map((e) => e.imageToUse).toList(),
        previousImages: previousImages,
      );

      PostModel? result = await PostService.editPost(editPostRequest);

      if (result != null) {
        context.go("/detail/${result.id}");
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      CreatePostRequest createPostRequest = CreatePostRequest(
          title: titleController.text,
          content: descriptionController.text,
          postType: widget.type,
          price: priceController.text.isEmpty
              ? null
              : int.parse(priceController.text),
          images: selectedImages.map((e) => e.imageToUse).toList());

      PostModel? result = await PostService.createPost(createPostRequest);

      if (result != null) {
        context.go("/detail/${result.id}");
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  bool _validate() {
    if (widget.type == "SALE" && priceController.text.isEmpty) {
      priceError = "You should enter price to sell something.";
    } else {
      priceError = null;
    }

    if (descriptionController.text.length < 30) {
      contentError = "At least 30 characters written to description.";
    } else {
      contentError = null;
    }

    if (titleController.text.isEmpty) {
      titleError = "Title should be written.";
    } else {
      titleError = null;
    }

    setState(() {});

    return priceError == null && contentError == null && titleError == null;
  }

  PostModel _getMockPostModel() {
    return PostModel(
        id: "0",
        userId: "",
        title: titleController.text,
        content: descriptionController.text,
        images: previousImages,
        mockImages: selectedImages.map((e) => e.imageToUse).toList(),
        createdAt: DateTime.now(),
        price: double.tryParse(priceController.text),
        type: widget.type,
        ownerName: Program().userModel!.name,
        ownerEmail: Program().userModel!.email,
        ownerDepartment: Program().userModel!.departmant,
        ownerPhoto: Program().userModel!.profilePhoto,
        ownerUserId: Program().userModel!.id,
        isMock: true);
  }
}
